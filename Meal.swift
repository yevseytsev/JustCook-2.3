//  Meal.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-авг.-3.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit
import CoreData

class Meal {
    
    //Properties
    var name: String?
    var type: String?
    var time: String?
    var servings: String?
    var difficulcy: NSNumber?
    var recommended_type: String?
    var recommended_name: String?
    var main_photo: UIImage?
    var ingredients = [String]()
    var quntity = [String]()
    var steps = [String]()
    var photos = [UIImage]()
    var id = 0.0
    var serverID: String?
    var auth: String?
    var isTemp: Bool?
    var facebookID: String?
    
    init() {}
    
    init(json: Dictionary<String, Any>) {
        
        auth = json["auth"] as? String
        name = json["name"] as? String
        type = json["type"] as? String
        time = json["time"] as? String
        servings = json["serving"] as! String?
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        difficulcy = formatter.number(from: (json["difficuity"] as! String))
        
        recommended_name = json["recommended"] as? String
        recommended_type = json["recomdType"] as? String
        
        serverID = json["serverID"] as! String?
        
        //photo
        let photoCollection = json["photos"] as! [Dictionary<String, String>]
        if photoCollection.count > 0 {
            
            for i in 0..<photoCollection.count {
                
                let image = UIImage(data: Data(base64Encoded: photoCollection[i]["data"]!)!)
                if i == 0 {
                    main_photo = image
                }
                else {
                    photos.append(image!)
                }
            }
        }
        
        let stepsJson = json["steps"] as! Array<Dictionary<String, String>>
        for step in stepsJson {
            steps.append(step["step"]!)
        }
        
        let ings = json["ings"] as! Array<Dictionary<String, String>>
        for ing in ings {
            ingredients.append(ing["ingredient"]!)
            quntity.append(ing["quantity"]!)
        }
        
    }
    
    //Initialisation
    init(recipeEntity: Recipe) {
        
        name = recipeEntity.name
        type = recipeEntity.type
        time = recipeEntity.time
        servings = recipeEntity.serving
        difficulcy = recipeEntity.difficulty
        recommended_name = recipeEntity.recommended
        recommended_type = recipeEntity.recommended_type
        isTemp = recipeEntity.isTemp
        facebookID = recipeEntity.facebookID
        serverID = recipeEntity.serverID ?? ""
        
        if let coreDataID = recipeEntity.id {
            id = coreDataID.doubleValue
        }
        serverID = recipeEntity.serverID ?? ""
        
        let sorter = NSSortDescriptor(key: "index", ascending: true)
        
        if (recipeEntity.photos?.count)! > 0 {
            print((recipeEntity.photos?.count)!)
            if let photos:[Photo] = recipeEntity.photos?.sortedArray(using: [sorter]) as! [Photo]? {
                for i in 0..<photos.count {
                    let image = UIImage(data: photos[i].photo!)
                    if i == 0 {
                        main_photo = image
                    }
                    else {
                        self.photos.append(image!)
                    }
                }
            }
        }
        
        if let ingredients:[Ingredient] = recipeEntity.ingredients?.sortedArray(using: [sorter]) as! [Ingredient]? {
            for i in 0..<ingredients.count {
                self.ingredients.append(ingredients[i].ingredient!)
                self.quntity.append(ingredients[i].quantity!)
            }
        }
        
        if let steps:[Step] = recipeEntity.steps?.sortedArray(using: [sorter]) as! [Step]? {
            for i in 0..<steps.count {
                self.steps.append(steps[i].step!)
            }
        }
    }
}
