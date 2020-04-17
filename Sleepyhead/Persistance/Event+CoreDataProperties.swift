//
//  Event+CoreDataProperties.swift
//  Sleepyhead
//
//  Created by mac on 17/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var startDate: Date
    @NSManaged public var typeIdentifier: Int16
    var type: EnventType {
        get {
            guard let type = EnventType(rawValue: Int(typeIdentifier)) else {
                fatalError("Value used for creating Event type must be 0 or 1")
            }
            return type
        }
        set {
            typeIdentifier = Int16(newValue.rawValue)
        }
    }
}
