//
//  GlobalFunctions.swift
//  Sleepyhead
//
//  Created by mac on 12/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

func printEntries(_ entries: [Event]) {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    for entry in entries {
        print(entry.type)
        print("Start: \(dateFormatter.string(from: entry.startDate))")
    }
}
