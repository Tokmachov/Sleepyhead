//
//  Entry.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct Entry {
    let startDate: Date
    var endEndDate: Date?
    let type: EntryType
    var duration: TimeInterval? {
        if endEndDate == nil {
            return Date().timeIntervalSince(startDate)
        } else {
            return startDate.distance(to: endEndDate!)
        }
    }
    enum EntryType {
        case wakeTime
        case goToSleepTime
    }
}




