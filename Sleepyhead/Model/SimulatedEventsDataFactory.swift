//
//  EntriesSimulationFactory.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct SimulatedEventsDataFactory {
    static private let durations: [TimeInterval] = [3600, 4000, 5000, 7200, 10800, 14400, 18000]
    static private let dayStartTimes: [(hour: Int, minute: Int)] = [(07, 45), (07, 50), (08, 00), (08, 15)]
    static private let nightSleepStartTimes: [(hour: Int, minute: Int)] = [(21, 00), (21, 15), (21, 25), (21, 30)]
    static var currentDay: (day: Int, month: Int, year: Int) = (12, 04, 2020)

    static func makeEventsSimulatedData(numberOfDays: Int) -> [EventData] {
        var eventsData = [EventData]()
        for _ in 1...numberOfDays {
            let firstEventData = makeFirstEventData(previousEventDatas: eventsData, dayStartTimes: dayStartTimes, durations: durations, currentDay: currentDay)
            let nightSleepEntry = makeNightSleepEventData(nightSleepStartTimes: nightSleepStartTimes, day: currentDay)
            currentDay.day += 1
            let nextMorningWakeEntry = makeNextMorningWakeEventData(dayStartTimes: dayStartTimes, day: currentDay)
            let entriesForDay = makeEventsDataForDay(firstEvetData: firstEventData, nightSleepStartEntry: nightSleepEntry, nextMorningWakeEntry: nextMorningWakeEntry, durations: durations)
            eventsData.append(contentsOf: entriesForDay)
        }
        return eventsData
    }

    static private func makeFirstEventData(
        previousEventDatas: [EventData],
        dayStartTimes: [(hour: Int, minute: Int)],
        durations: [TimeInterval],
        currentDay: (day: Int, month: Int, year: Int)
    ) -> EventData {
        if let eventData = previousEventDatas.last {
            let duration = durations.randomElement()!
            let date = eventData.startDate.addingTimeInterval(duration)
            return EventData(startDate: date, eventType: .sleepTime)
        } else {
            let dayStartTime = dayStartTimes.randomElement()!
            let date = makeDate(time: dayStartTime, day: currentDay)
            return EventData(startDate: date, eventType: .wakeTime)
        }
    }

    static private func makeNightSleepEventData(nightSleepStartTimes: [(hour: Int, minute: Int)], day: (day: Int, month: Int, year: Int)) -> EventData {
        let time = nightSleepStartTimes.randomElement()!
        let date = makeDate(time: time, day: day)
        return EventData(startDate: date, eventType: .sleepTime)
    }

    static private func makeNextMorningWakeEventData(dayStartTimes: [(hour: Int, minute: Int)], day: (day: Int, month: Int, year: Int)) -> EventData {
        let time = dayStartTimes.randomElement()!
        let date = makeDate(time: time, day: day)
        return EventData(startDate: date, eventType: .wakeTime)
    }

    static private func makeEventsDataForDay(firstEvetData: EventData, nightSleepStartEntry: EventData, nextMorningWakeEntry: EventData, durations: [TimeInterval]) -> [EventData] {
        var eventData = firstEvetData
        var eventsData = [EventData]()
        while eventData.startDate < nightSleepStartEntry.startDate {
            eventsData.append(eventData)
            let duration = durations.randomElement()!
            let nextDate = eventData.startDate.addingTimeInterval(duration)
            if eventsData.last!.eventType == .sleepTime {
                eventData = EventData(startDate: nextDate, eventType: .wakeTime)
            } else {
                eventData = EventData(startDate: nextDate, eventType: .sleepTime)
            }
        }
        if eventsData.last!.eventType == .sleepTime {
            eventsData.removeLast()
        }
        eventsData.append(nightSleepStartEntry)
        eventsData.append(nextMorningWakeEntry)
        return eventsData
    }

    static private func makeDate(time: (hour: Int, minute: Int), day: (day: Int, month: Int, year: Int)) -> Date {
        let dateCompoents = DateComponents(
            calendar: .current,
            timeZone: .current,
            era: nil,
            year: day.year,
            month: day.month,
            day: day.day,
            hour: time.hour,
            minute: time.minute,
            second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return dateCompoents.date!
    }
    struct  EventData {
        let startDate: Date
        let eventType: EventType
    }
}
