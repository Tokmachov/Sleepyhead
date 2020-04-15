//
//  Entries.swift
//  Sleepyhead
//
//  Created by mac on 15/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct EntriesStorage {
    private(set) var entries: [Entry]
    subscript(index: Int) -> Entry? {
        get {
            if entries.indices.contains(index) {
                return entries[index]
            } else {
                return nil
            }
        }
    }
    func duration(of entry: Entry) -> TimeInterval? {
        guard let index = entries.firstIndex(of: entry) else { return nil }
        guard let indexOfNexEtry = entries.index(
            index,
            offsetBy: 1,
            limitedBy: entries.endIndex - 1
            ) else {
            return entry.startDate.distance(to: Date())
        }
        let nextEntry = entries[indexOfNexEtry]
        return entry.startDate.distance(to: nextEntry.startDate)
    }
    init() {
        self.entries = SimulatedEntriesFactory.makeEntries(numberOfDays: 2)
    }
}
