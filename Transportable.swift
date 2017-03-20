//
//  Server.swift
//  Just Cook
//
//  Created by lei zhang on 2016-12-25.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//
import Foundation
import UIKit
import SystemConfiguration

// check network and user status:
func networkChecker() -> (Bool, String) {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return (false, NSLocalizedString("Internet is required for publishing or searching recipes", comment: "-"))
    }
    
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    
    if (isReachable == false || needsConnection) {
        return (false, NSLocalizedString("Internet is required for publishing or searching recipes", comment: "-"))
    }
    
    return (true, "success")
}

func facebookChecker() -> (Bool, String) {
    if let facebookID = UserDefaults.standard.string(forKey: Constants.FACEBOOK_ID) {
        if facebookID.characters.count == 0 {
            return (false, NSLocalizedString("Need to login with Facebook for using publishing or searching recipes", comment: "-"))
        }
    }
    else {
        return (false, NSLocalizedString("Need to login with Facebook for using publishing or searching recipes", comment: "-"))
    }
    
    return (true, "success")
}

protocol Transportable: class {
    var meal : Meal! { get set }
}

extension Transportable {
    
    private func convertMealToJSONData() -> Data? {
        let facebookID = UserDefaults.standard.string(forKey: Constants.FACEBOOK_ID) ?? ""
        let auth = UserDefaults.standard.string(forKey: Constants.FACEBOOK_USERNAME) ?? ""
        
        var body: Dictionary<String, Any> = ["auth": auth,
                                             "facebookID": facebookID,
                                             "difficuity": meal.difficulcy!,
                                             "name": meal.name!,
                                             "recommended": meal.recommended_name ?? "",
                                             "recomdType": meal.recommended_type ?? "",
                                             "serving": meal.servings!,
                                             "time": meal.time!,
                                             "type": meal.type!,
                                             "serverID": meal.serverID ?? ""]
        
        var ings =  [Dictionary<String, String>]()
        
        for i in 0..<meal.ingredients.count {
            var ingDic = Dictionary<String, String>()
            ingDic["ingredient"] = meal.ingredients[i]
            ingDic["quantity"] = meal.quntity[i]
            ings.append(ingDic)
        }
        
        body["ings"] = ings
        
        
        var steps = [Dictionary<String, String>]()
        
        for step in meal.steps {
            steps.append(["step": step])
        }
        
        body["steps"] = steps
        
        
        var photos = [Dictionary<String, String>]()
        
        if meal.main_photo != nil {
            let data = UIImagePNGRepresentation(meal.main_photo!)
            
            let base64: String! = data?.base64EncodedString()
            
            photos.append(["data": base64])
        }
        
        body["photos"] = Array<Dictionary<String, String>>()
        
        //print(body.description)
        
        var data = Data()
        do {
            data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return data
    }
    
    func uploadRecipe(toOrder orderOption: String?, feedback: @escaping (_ msg:String)->()) {
        let network = networkChecker()
        guard network.0  else {
            DispatchQueue.main.async {
                feedback(network.1)
            }
            return
        }
        
        let fb = facebookChecker()
        guard fb.0 || orderOption != nil else {
            DispatchQueue.main.async {
                feedback(fb.1)
            }
            return
        }
        
        guard let body = convertMealToJSONData() else {
            DispatchQueue.main.async {
                feedback("convert json fail")
            }
            return
        }
        
        let endpoint:String!
        
        if orderOption != nil {
            endpoint = Constants.UPLOAD_RECIPE_TO_ORDER
        }
        else {
            endpoint = Constants.SEND_RECIPE
        }
        
        guard let serviceUrl = URL(string: Constants.SERVER + endpoint) else
        {
            DispatchQueue.main.async {
                feedback("Invalid URL")
            }
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(orderOption ?? "", forHTTPHeaderField: "id")
        
        request.httpBody = body
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard err == nil else {
                DispatchQueue.main.async {
                    feedback((err?.localizedDescription)!)
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String]
                
                self.meal.serverID = json["message"]
                
                guard let photo = self.meal.main_photo, let serverID = json["message"] else {
                    DispatchQueue.main.async {
                        feedback(json["message"]!)
                    }
                    return
                }
                
                self.meal.photos.insert(photo, at: 0)
                
                DispatchQueue.global(qos: .background).async {
                    ImageManager.sharedManager.uploadImages(self.meal.photos, name: self.meal.name!, recipeID: serverID, orderID: orderOption)
                }
                
                DispatchQueue.main.async {
                    feedback(json["message"]!)
                }
                
            } catch {
                feedback((error.localizedDescription))
                return
            }
        }
        
        task.resume()
    }
    
    public func deleteRecipe(feedback: @escaping (_ msg:String)->()) {
        
        let network = networkChecker()
        guard network.0 else {
            DispatchQueue.main.async {
                feedback(network.1)
            }
            return
        }
        
        let fb = facebookChecker()
        guard fb.0 else {
            DispatchQueue.main.async {
                feedback(fb.1)
            }
            return
        }
        
        guard meal.serverID != nil else {
            return
        }
        
        var facebookID = UserDefaults.standard.string(forKey: Constants.FACEBOOK_ID)!
        facebookID = facebookID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        guard let serviceUrl = URL(string: Constants.SERVER + Constants.DELETE_RECIPE + meal.serverID! + "_" + facebookID) else
        {
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request, completionHandler: {(d,r,e)in self.meal.serverID = ""
        }).resume()
    }
    
    public func downloadRecipe(by id:String, feedback: @escaping (_ errMsg: String, _ recipe: Recipe?)->()) {
        let network = networkChecker()
        guard network.0 else {
            DispatchQueue.main.async {
                feedback(network.1, nil)
            }
            return
        }
        
        let fb = facebookChecker()
        guard fb.0 else {
            DispatchQueue.main.async {
                feedback(network.1, nil)
            }
            return
        }
        
        guard let serviceUrl = URL(string: Constants.SERVER + Constants.DOWNLOAD_BY_ID + id) else
        {
            DispatchQueue.main.async {
                feedback("Invalid URL", nil)
            }
            return
        }
        
        var request = URLRequest(url: serviceUrl)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard err == nil else {
                feedback((err?.localizedDescription)!, nil)
                return
            }
            
            guard data != nil else {
                feedback("NO Data)", nil)
                return
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
                
                DispatchQueue.main.async {
                    self.meal = Meal(json: json)
                    
                    let manager = CoreDataManeger.sharedManager
                    let recipe = manager.saveMealTOCoreData(meal: self.meal)
                    
                    feedback("", recipe)
                }
                
            } catch {
                feedback(error.localizedDescription, nil)
                return
            }
        }
        
        task.resume()
    }
}
