//
//  EventType.swift
//  Sleepyhead
//
//  Created by mac on 17/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

enum EnventType: Int {
        case wakeTime = 0
        case sleepTime = 1
}

enum PositionOfEventInTheDay {
       case dayStarting
       case dayFinishing
       case dayFilling
   }
