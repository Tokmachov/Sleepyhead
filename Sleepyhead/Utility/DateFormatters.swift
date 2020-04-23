//
//  DateFormatters.swift
//  Sleepyhead
//
//  Created by mac on 22/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct DateFormatters {
    static var eventStartDateFormatter: DateFormatter {
       let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter
    }
    static func eventDurationFormatter(forCellAtLastPosition isLast: Bool) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        if isLast {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.hour, .minute]
        }
        return formatter
    }
}
