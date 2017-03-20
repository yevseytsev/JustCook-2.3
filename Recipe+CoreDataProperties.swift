//
//  Recipe+CoreDataProperties.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-29.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var difficulty: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var recommended: String?
    @NSManaged public var serving: String?
    @NSManaged public var time: String?
    @NSManaged public var type: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var photos: NSSet?
    @NSManaged public var steps: NSSet?
    @NSManaged public var recommended_type: String?
    @NSManaged public var serverID: String?
    @NSManaged public var auth: String?
    @NSManaged public var facebookID: String?
    @NSManaged public var isTemp: Bool
    @NSManaged public var isDownloaded: Bool
}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension Recipe {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

// MARK: Generated accessors for steps
extension Recipe {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: Step)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: Step)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}
