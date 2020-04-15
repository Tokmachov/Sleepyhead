//
//  EntriesSimulationFactory.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct SimulatedEntriesFactory {
    static private let durations: [TimeInterval] = [3600, 4000, 5000, 7200, 10800, 14400, 18000]
    static private let dayStartTimes: [(hour: Int, minute: Int)] = [(07, 45), (07, 50), (08, 00), (08, 15)]
    static private let nightSleepStartTimes: [(hour: Int, minute: Int)] = [(21, 00), (21, 15), (21, 25), (21, 30)]
    static var currentDay: (day: Int, month: Int, year: Int) = (12, 04, 2020)

    static func makeEntries(numberOfDays: Int) -> [Event] {
        var entries = [Event]()
        for _ in 1...numberOfDays {
            let firstEntry = makeFirstEntry(previousEntries: entries, dayStartTimes: dayStartTimes, durations: durations, currentDay: currentDay)
            let nightSleepEntry = makeNightSleepEntry(nightSleepStartTimes: nightSleepStartTimes, day: currentDay)
            currentDay.day += 1
            let nextMorningWakeEntry = makeNextMorningWakeEntry(dayStartTimes: dayStartTimes, day: currentDay)
            let entriesForDay = makeEntriesForDay(firstEntry: firstEntry, nightSleepStartEntry: nightSleepEntry, nextMorningWakeEntry: nextMorningWakeEntry, durations: durations)
            entries.append(contentsOf: entriesForDay)
            entries = entriesWithEndDatesSet(entries)
        }
        return entries
    }

    static private func makeFirstEntry(
        previousEntries: [Event],
        dayStartTimes: [(hour: Int, minute: Int)],
        durations: [TimeInterval],
        currentDay: (day: Int, month: Int, year: Int)
    ) -> Event {
        if let entry = previousEntries.last {
            let duration = durations.randomElement()!
            let date = entry.startDate.addingTimeInterval(duration)
            return Event(startDate: date, endEndDate: nil, type: .goToSleepTime)
        } else {
            let dayStartTime = dayStartTimes.randomElement()!
            let date = makeDate(time: dayStartTime, day: currentDay)
            return Event(startDate: date, endEndDate: nil, type: .wakeTime)
        }
    }

    static private func makeNightSleepEntry(nightSleepStartTimes: [(hour: Int, minute: Int)], day: (day: Int, month: Int, year: Int)) -> Event {
        let time = nightSleepStartTimes.randomElement()!
        let date = makeDate(time: time, day: day)
        return Event(startDate: date, endEndDate: nil, type: .goToSleepTime)
    }

    static private func makeNextMorningWakeEntry(dayStartTimes: [(hour: Int, minute: Int)], day: (day: Int, month: Int, year: Int)) -> Event {
        let time = dayStartTimes.randomElement()!
        let date = makeDate(time: time, day: day)
        return Event(startDate: date, endEndDate: nil, type: .wakeTime)
    }

    static private func makeEntriesForDay(firstEntry: Event, nightSleepStartEntry: Event, nextMorningWakeEntry: Event, durations: [TimeInterval]) -> [Event] {
        var entry = firstEntry
        var entries = [Event]()
        while entry.startDate < nightSleepStartEntry.startDate {
            entries.append(entry)
            let duration = durations.randomElement()!
            let nextDate = entry.startDate.addingTimeInterval(duration)
            if entries.last!.type == .goToSleepTime {
                entry = Event(startDate: nextDate, endEndDate: nil, type: .wakeTime)
            } else {
                entry = Event(startDate: nextDate, endEndDate: nil, type: .goToSleepTime)
            }
        }
        if entries.last!.type == .goToSleepTime {
            entries.removeLast()
        }
        entries.append(nightSleepStartEntry)
        entries.append(nextMorningWakeEntry)
        return entries
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

    static private func entriesWithEndDatesSet(_ entries: [Event]) -> [Event] {
        var mutableEntries = entries
        var counter = 0
        while counter < (entries.count - 1) {
            mutableEntries[counter].endEndDate = mutableEntries[counter + 1].startDate
            counter += 1
        }
        return mutableEntries
    }
}
