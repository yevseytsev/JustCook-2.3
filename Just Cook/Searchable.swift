//
//  Searchable.swift
//  Just Cook
//
//  Created by lei zhang on 2017-01-02.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//
import Foundation

class RecipeIndex {
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    fileprivate(set) var auth: String
    fileprivate(set) var type: String
    init(id: String, name: String, auth:String, type: String) {
        self.id = id
        self.name = name
        self.auth = auth
        self.type = type
    }
}

protocol Serachable {
    var name: String? { get }
}

extension Serachable {
    func searchByName(completetionHandle: @escaping ([RecipeIndex], _ errorMessage: String?) -> ()) {
        
        let network = networkChecker()
        guard network.0 else {
            DispatchQueue.main.async {
                completetionHandle([RecipeIndex](), network.1)
            }
            return
        }
        
        let fb = facebookChecker()
        
        guard fb.0 else {
            DispatchQueue.main.async {
                completetionHandle([RecipeIndex](), fb.1)
            }
            return
        }
        
        
        let serviceUrl = URL(string: Constants.SERVER + Constants.SEARCH_RECIPE_BY_NAME + name!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        
        // print(serviceUrl?.description)
        
        var request = URLRequest(url: serviceUrl!)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, err) in
            
            guard err == nil else {
                DispatchQueue.main.async {
                    completetionHandle([RecipeIndex](),(err?.localizedDescription)!)
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<Dictionary<String, String>>
                
                var results = [RecipeIndex]()
                
                for index in json {
                    results.append(RecipeIndex(id: index["dbID"]!, name: index["name"]!, auth: index["auth"]!, type: index["type"]!))
                }
                
                DispatchQueue.main.async {
                    completetionHandle(results,nil)
                }
                
            }catch {
                completetionHandle([RecipeIndex](),(err?.localizedDescription)!)
                return
            }
        }
        
        task.resume()
        
    }
}
