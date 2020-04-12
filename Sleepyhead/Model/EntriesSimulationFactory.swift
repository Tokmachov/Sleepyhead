//
//  EntriesSimulationFactory.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct EntriesFactory {
    static private let dayDuration: TimeInterval = 60 * 60 * 24
    static var startOfPeriod: (day: Int, month: Int, hour: Int, minute: Int, second: Double) = (4, 10, 7, 41, 55)
    static func makeEntries() -> [Entry] {
        let durations: [TimeInterval] = [3600, 4000, 5000, 7200, 10800, 14400, 18000]
        
       
        return [Entry]()
    }
    static private func makeDate(components: (day: Int, month: Int, hour: Int, minute: Int, second: Double)) -> Date {
        let dateComponents = DateComponents(calendar: .current, timeZone: .current, era: .none, year: 2020, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return dateComponents.date!
    }
}
