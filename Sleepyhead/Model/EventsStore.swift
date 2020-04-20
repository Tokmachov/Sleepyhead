//
//  Entries.swift
//  Sleepyhead
//
//  Created by mac on 15/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct EventsStore {
    private var events: [Event]
    
    init(events: [Event]) {
        self.events = events
    }
    var observedDaysCount: Int {
        return observedDays.count
    }
    func eventsCount(perDayAtIndex index: Int) -> Int {
        return observedDays[index].events.count
    }
    var indexOfLastDay: Int {
        return observedDays.count - 1
    }
    var indexOfLastEventInLastDay: Int {
        let lastObservedDay = observedDays.last!
        return lastObservedDay.events.endIndex - 1
    }
    var eventForTimeUpdates: Event? {
        return events.last
    }
    subscript(dayIndex: Int, eventIndex: Int) -> Event {
        get {
            return observedDays[dayIndex].events[eventIndex]
        }
    }
    subscript(dayIndex: Int) -> ObservedDay {
        return observedDays[dayIndex]
    }
    func duration(of event: Event) -> TimeInterval {
        let index = events.firstIndex(of: event)!
        let indexOfNextEntry = index + 1
        if indexOfNextEntry < events.endIndex {
            let nextEvent = events[indexOfNextEntry]
            return event.startDate.distance(to: nextEvent.startDate)
        } else {
            return event.startDate.distance(to: Date())
        }
    }
    func positionOfeventInADay(_ event: Event) -> PositionOfEventInTheDay {
        let dayThatHasEvent = observedDays.first { $0.events.contains(event) }!
        switch event {
        case dayThatHasEvent.events.first: return .dayStarting
        case dayThatHasEvent.events.last where dayThatHasEvent != observedDays.last: return .dayFinishing
        default: return .dayFilling
        }
    }
    func numberOfSleepEventInADay(_ event: Event) -> Int {
        let dayThatHasEvent = observedDays.first { $0.events.contains(event) }!
        let sleepEvents = dayThatHasEvent.events.filter { $0.type == .sleepTime }
        let indexIfSleepEvent = sleepEvents.firstIndex(of: event)!
        return indexIfSleepEvent + 1
    }
}

extension EventsStore {
    struct ObservedDay: Equatable {
        let date: DayDate
        let events: [Event]
    }
    
    struct DayDate: Comparable, Hashable {
        let day: Int
        let month: Int
        let year: Int
        // Equatable
        static func == (lhs: DayDate, rhs: DayDate) -> Bool {
            return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
        }
        //Comparable
        static func < (lhs: DayDate, rhs: DayDate) -> Bool {
            if lhs.year != rhs.year {
                return lhs.year < rhs.year
            } else if lhs.month != rhs.month {
                return lhs.month < rhs.month
            } else {
                return lhs.day < rhs.day
            }
        }
        //Hashabe
        func hash(into hasher: inout Hasher) {
            hasher.combine(day)
            hasher.combine(month)
            hasher.combine(year)
        }
    }
    private var observedDays: [ObservedDay] {
        var observedDays = createObservedDays(from: events)
        observedDays.sort { $0.date < $1.date }
        return observedDays
    }
    
    private func createObservedDays(from events: [Event]) -> [ObservedDay] {
        let dayDatesAndEvents = Dictionary(grouping: events) { (event: Event) -> DayDate in
            let dateComponents = createDateComponents(from: event.startDate)
            let dayDate = DayDate(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
            return dayDate
        }
        let observedDays = dayDatesAndEvents.map { ObservedDay(date: $0.key, events: $0.value) }
        return observedDays
    }
    private func createDateComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        let componentsToExtract: Set<Calendar.Component> = [.month, .day, .year]
        let dateComponents = calendar.dateComponents(componentsToExtract, from: date)
        return dateComponents
    }
}
