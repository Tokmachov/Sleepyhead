//
//  SleepLogColors.swift
//  Sleepyhead
//
//  Created by mac on 22/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

struct SleepLogColors {
    static func cellBackground(for eventType: EventType) -> UIColor {
        switch eventType {
        case .sleepTime: return #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 0.4000695634)
        case .wakeTime: return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.4504227312)
        }
    }
}
