//
//  CoreDataManager.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-24.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManeger {
    
    var moc:NSManagedObjectContext { return self.persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Just_Cook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func create(entity: String) -> NSManagedObject {
        let mo = NSEntityDescription.insertNewObject(forEntityName: entity, into: self.moc)
        saveContext()
        return mo
    }
    
    func createPhotoEntity() -> Photo {
        let photo: Photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: persistentContainer.viewContext) as! Photo
        
        saveContext()
        
        return photo
    }
    
}

extension CoreDataManeger {
    static let sharedManager = CoreDataManeger()
    
    var managedObjectContext: NSManagedObjectContext  { return persistentContainer.viewContext}
    
    func CreateRecipe() -> Recipe {
        let recipe: Recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: persistentContainer.viewContext) as! Recipe
        recipe.id = NSDate().timeIntervalSince1970 as NSNumber?;
        
        saveContext()
        
        return recipe
    }
    
    func delete(recipe: Recipe){
        persistentContainer.viewContext.delete(recipe)
        saveContext()
    }
    
    func getAllRecipes() -> [Recipe] {
        let request = NSFetchRequest<Recipe>()
        request.entity = NSEntityDescription.entity(forEntityName: "Recipe", in: moc)
        request.predicate = NSPredicate(value: true)
        
        do{
            let results = try moc.fetch(request)
            return results
        } catch {
            fatalError("Failed to fetch Recipe:\(error)")
        }
    }
    
    func deleteStep(from recipe: Recipe) {
        let request = NSFetchRequest<Step>();
        request.entity = NSEntityDescription.entity(forEntityName: "Step", in: moc)
        request.predicate = NSPredicate(format: "recipe = %@", recipe)
        
        do {
            let results = try moc.fetch(request)
            
            for step in results {
                recipe.removeFromSteps(step)
            }
            
            saveContext()
        }catch {
            fatalError("Failed to fetch Recipe: \(error)")
        }
    }
    
    func deleteIngs(from recipe: Recipe) {
        let request = NSFetchRequest<Ingredient>();
        request.entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: moc)
        request.predicate = NSPredicate(format: "recipe = %@", recipe)
        do {
            let results = try moc.fetch(request)
            
            for ingredient in results {
                recipe.removeFromIngredients(ingredient)
            }
            saveContext()
        }catch {
            fatalError("Failed to fetch Recipe: \(error)")
        }
    }
    
    func deletePhotos(from recipe:Recipe) {
        let request = NSFetchRequest<Photo>();
        request.entity = NSEntityDescription.entity(forEntityName: "Photo", in: moc)
        request.predicate = NSPredicate(format: "recipe = %@", recipe)
        do {
            let results = try moc.fetch(request)
            
            for pho in results {
                recipe.removeFromPhotos(pho)
            }
            saveContext()
        }catch {
            fatalError("Failed to fetch Recipe: \(error)")
        }
    }
    
    func update(recipe : Recipe, data : Dictionary<String, AnyObject>){
        recipe.setValuesForKeys(data)
        saveContext()
    }
    
    func add(ingredient : Ingredient, to recipe : Recipe){
        recipe.addToIngredients(ingredient)
        saveContext()
    }
    
    func add(photo : Photo, to recipe : Recipe){
        recipe.addToPhotos(photo)
        saveContext()
    }
    
    func saveMealTOCoreData(meal: Meal) -> Recipe {
        let recipe = CreateRecipe()
        
        recipe.serving = meal.servings
        recipe.difficulty = meal.difficulcy
        recipe.name = meal.name
        recipe.recommended = meal.recommended_name
        recipe.recommended_type = meal.recommended_type
        recipe.time = meal.time
        recipe.type = meal.type
        recipe.serverID = meal.serverID
        recipe.auth = meal.auth
        recipe.isDownloaded = true
        recipe.isTemp = true
        
        for i in 0..<meal.ingredients.count {
            let ingredient: Ingredient = create(entity: "Ingredient") as! Ingredient
            ingredient.setValuesForKeys(["Ingredient":meal.ingredients[i], "index": i, "quantity": meal.quntity[i]])
            recipe.addToIngredients(ingredient)
        }
        
        for i in 0..<meal.steps.count {
            let direction: Step = create(entity: "Step") as! Step
            direction.setValuesForKeys(["step":meal.steps[i], "index": i])
            recipe.addToSteps(direction)
        }
        
        
        if meal.main_photo != nil {
            let photo: Photo = create(entity: "Photo") as! Photo
            let imageData = UIImagePNGRepresentation(meal.main_photo!)
            photo.setValuesForKeys(["photo": imageData, "index": 0])
            recipe.addToPhotos(photo)
        }
        
        if meal.photos.count > 0 {
            for i in 0..<meal.photos.count{
                let photo: Photo = create(entity: "Photo") as! Photo
                let imageData = UIImagePNGRepresentation(meal.photos[i])
                photo.setValuesForKeys(["photo": imageData, "index": i + 1])
                recipe.addToPhotos(photo)
            }
        }
        
        saveContext()
        
        return recipe
    }
    
    func deleteTempReceipe() {
        
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        /***/
        request.predicate = NSPredicate(format: "isTemp = true or isFinished = false")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchRecipeBy(_ serverID: String) -> Recipe? {
        let request = NSFetchRequest<Recipe>()
        request.entity = NSEntityDescription.entity(forEntityName: "Recipe", in: moc)
        request.predicate = NSPredicate(format: "serverID = %@", serverID)
        
        do{
            let results = try moc.fetch(request)
            
            if results.count > 0 {
                return results.first
            }
            else {
                return nil
            }
            
        } catch {
            fatalError("Failed to fetch Recipe:\(error)")
        }
        
    }
    
    func fetchAllAvailableRecipe() -> [Recipe] {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        request.predicate = NSPredicate(format: "isTemp = false and isFinished = true")
        
        do {
            return try moc.fetch(request)
        } catch {
            fatalError("Failed to fetch Recipe:\(error)")
        }
        
    }
    
    func deleteAll(){
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.predicate = NSPredicate(value: true)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
}
