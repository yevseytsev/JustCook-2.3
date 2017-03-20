//
//  Ingredient+CoreDataProperties.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-29.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient");
    }

    @NSManaged public var ingredient: String?
    @NSManaged public var quantity: String?
    @NSManaged public var recipe: Recipe?
    @NSManaged public var index: Int16

}
