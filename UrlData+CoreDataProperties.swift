//
//  UrlData+CoreDataProperties.swift
//  URL Shortner App
//
//  Created by Ali Afzal on 10/10/2022.
//
//

import Foundation
import CoreData


extension UrlData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UrlData> {
        return NSFetchRequest<UrlData>(entityName: "UrlData")
    }

    @NSManaged public var original_link: String?
    @NSManaged public var short_link: String?

}

extension UrlData : Identifiable {

}
