//
//  Entry.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct Entry {
    let startTime: Date
    let endTime: Date?
    var isInProcess: Bool
    let type: EntryType
    var duration: TimeInterval? {
        if isInProcess {
            return Date().timeIntervalSince(startTime)
        }
        if let endTime = endTime {
            return endTime.timeIntervalSince(startTime)
        } else {
            return nil
        }
    }
    enum EntryType {
        case wakeTime
        case goToSleepTime
    }
}




