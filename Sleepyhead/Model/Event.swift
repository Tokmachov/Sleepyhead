//
//  Entry.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct Event {
    let startDate: Date
    let type: EntryType
    enum EntryType {
        case wakeTime
        case goToSleepTime
    }
}
extension Event: Equatable {}



