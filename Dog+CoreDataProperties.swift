//
//  Dog+CoreDataProperties.swift
//  My Dogs
//
//  Created by Menaim on 20/12/2021.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var dogName: String?
    @NSManaged public var dogColor: String?
    @NSManaged public var dogFavoriteTreat: String?
    @NSManaged public var dogImage: Data?

}

extension Dog : Identifiable {

}
