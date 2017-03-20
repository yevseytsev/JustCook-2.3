//
//  ordering.swift
//  Just Cook
//
//  Created by Excellence on 11/24/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation

class Address: NSObject {
    var name: String!
    var address1: String!
    var address2: String?
    var city: String!
    var zipCode: String!
    var state: String?
    var country: String!
    var email: String?
    var phone: String?
    
    var dictionary: Dictionary<String, Any> {
        return [ "name": name,
                 "address1": address1,
                 "address2": address2 ?? "",
                 "city": city,
                 "zipCode": zipCode,
                 "state": state ?? "",
                 "country": country,
                 "email": email ?? "",
                 "phone": phone ?? ""]
    }
}

class Order: NSObject {
    var book_type: Int!
    var author: String!
    var color: String!
    var email: String!
    var address: Address?
    
    let coredataManager = CoreDataManeger.sharedManager
}

extension Order {
    
    func convertOrderToJSONData() -> Data? {
        
        let body: Dictionary<String, Any> = ["bookType": book_type,
                                                "author": author,
                                                "color": color,
                                                "email": email,
                                                "address": (address != nil) ? address!.dictionary : Dictionary<String, Any>()]
        
        var data = Data()
        do {
            data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return data
    }
    
    func uploadOrder() {
        let network = networkChecker()
        guard network.0 else {
            DispatchQueue.main.async {
                print(network.1)
            }
            return
        }
        
        guard let body = convertOrderToJSONData() else {
            DispatchQueue.main.async {
                print("convert json fail")
            }
            return
        }

        let url = URL(string: Constants.SERVER + Constants.UPLOAD_ORDER)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard error == nil else {
                print((error?.localizedDescription)!)
                return
            }
            
            guard data != nil else {
                print("NO Data)")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                
                let orderHistory = self.coredataManager.create(entity: "OrderHistory") as! OrderHistory
                orderHistory.dbID = json["message"] as! String?
                self.coredataManager.saveContext()
                self.addRecipe(to: json["message"]! as! String)
            }catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func addRecipe(to OrderID: String) {
        // get all recipes
        let recipes = coredataManager.fetchAllAvailableRecipe()
        
        for recipe in recipes {
            MealContainer(Meal(recipeEntity: recipe)).uploadRecipe(toOrder: OrderID) {
                msg in
                
                if msg.compare(NSLocalizedString("Internet is required for publishing or searching recipes", comment: "-")) == .orderedSame || msg.compare(NSLocalizedString("Need to login with Facebook for using publishing or searching recipes", comment: "-")) == .orderedSame {
                    print(msg)
                    return
                }
                
                guard msg.characters.count <= 0 else {
                    print(msg)
                    return
                }
            }
        }
    }
}

class MealContainer: Transportable {
    var meal : Meal!
    init(_ meal: Meal) {
        self.meal = meal
    }
}



