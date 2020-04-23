//
//  EventControlColors.swift
//  Sleepyhead
//
//  Created by mac on 22/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

struct EventControlVCColors {
     static func buttonColor(for type: EventType) -> UIColor {
        return SleepLogColors.cellBackground(for: type)
     }
}
