//
//  Step+CoreDataProperties.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-29.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation
import CoreData


extension Step {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Step> {
        return NSFetchRequest<Step>(entityName: "Step");
    }

    @NSManaged public var step: String?
    @NSManaged public var recipe: Recipe?
    @NSManaged public var index: Int16

}
