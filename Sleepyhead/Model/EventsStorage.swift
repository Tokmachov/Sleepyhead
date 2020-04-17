//
//  Entries.swift
//  Sleepyhead
//
//  Created by mac on 15/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct EventsStorage {
    private(set) var events: [Event]
    subscript(index: Int) -> Event? {
        get {
            if events.indices.contains(index) {
                return events[index]
            } else {
                return nil
            }
        }
    }
    func duration(of event: Event) -> TimeInterval? {
        guard let index = events.firstIndex(of: event) else { return nil }
        guard let indexOfNexEtry = events.index(
            index,
            offsetBy: 1,
            limitedBy: events.endIndex - 1
            ) else {
            return event.startDate.distance(to: Date())
        }
        let nextEvent = events[indexOfNexEtry]
        return event.startDate.distance(to: nextEvent.startDate)
    }
}
