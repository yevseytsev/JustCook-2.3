//
//  Photo+CoreDataProperties.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-29.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photo: Data?
    @NSManaged public var recipe: Recipe?
    @NSManaged public var index: Int16

}
