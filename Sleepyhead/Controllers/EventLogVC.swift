//
//  ViewController.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class EventLogVC: UITableViewController {
    
    private var eventsStore: EventsStore!
    private var lastEntryDurationUpdateTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var events = [Event]()
        events = EventsPersistenceService.fetchEvents()
        if events.isEmpty {
            print("Evets were not fetched")
            let eventsData = SimulatedEventsDataFactory.makeEventsSimulatedData(numberOfDays: 3)
            events = eventsData.map { (eventData) -> Event in
                let event = Event(context: EventsPersistenceService.managedObjectContext)
                event.startDate = eventData.startDate
                event.type = eventData.eventType
                return event
            }
            EventsPersistenceService.saveContext()
        } else {
            print("Evets were fetched")
        }
        eventsStore = EventsStore(events: events)
        setLastEntryDurationUpdateTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastEntryDurationUpdateTimer?.invalidate()
    }
}

extension EventLogVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return eventsStore.observedDaysCount
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsStore.eventsCount(perDayAtIndex: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = eventsStore[indexPath.section, indexPath.row]
        let eventPositionInDay = eventsStore.positionOfeventInADay(event)
        let id = cellId(for: event.type, atPosition: eventPositionInDay)!
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        let factory = CellConfiguratorFactory(eventStore: eventsStore)
        let configureFucntion = factory.make(eventType: event.type, eventPosition: eventPositionInDay)!
        configureFucntion(cell, event)
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let string = stringForEventSectionHeader(section: section)
        let headerLabel = viewForEventsSectionHeader()
        headerLabel.text = string
        return headerLabel
    }
}

extension EventLogVC {
    private var indexPathOfCellForTimeUpdates: IndexPath {
        return IndexPath(row: eventsStore.indexOfLastEventInLastDay, section: eventsStore.indexOfLastDay)
    }
    private func setLastEntryDurationUpdateTimer() {
        lastEntryDurationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [self.indexPathOfCellForTimeUpdates], with: .fade)
        }
    }
    private func cellId(for eventType: EnventType, atPosition position: PositionOfEventInTheDay) -> String? {
        switch eventType {
        case .wakeTime where position == .dayStarting: return "DayStartingCell"
        case .wakeTime where position == .dayFilling: return "DayFillingWakeCell"
        case .sleepTime where position == .dayFinishing: return "DayFinishingSleepCell"
        case .sleepTime where position == .dayFilling: return "DayFillingSleepCell"
        default: return nil
        }
    }
}

//MARK: UI setups
extension EventLogVC {
    private func stringForEventSectionHeader(section: Int) -> String {
        let date = eventsStore[section].date
        let dateString = "Day: \(date.day).\(date.month).\(date.year)"
        return dateString
    }
    private func viewForEventsSectionHeader() -> UILabel {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.1949914384)
        return label
    }
    struct CellConfiguratorFactory {
        private var eventsStore: EventsStore
        init(eventStore: EventsStore) {
            self.eventsStore = eventStore
        }
        func make(eventType: EnventType, eventPosition: PositionOfEventInTheDay) -> ((UITableViewCell, Event) -> ())? {
            switch (eventType, eventPosition) {
            case (.wakeTime, .dayStarting): return configureDayStartingWakeCell(_:_:)
            case (.wakeTime, .dayFilling): return configureDayFillingWakeCell(_:_:)
            case (.sleepTime, .dayFinishing):  return configureDayFinishingSleepCell(_:_:)
            case (.sleepTime, .dayFilling):  return configureDayFillingSleepCell(_:_:)
            default: return nil
            }
        }
        private func configureDayStartingWakeCell(_ cell: UITableViewCell, _ event: Event) -> () {
            let isCellForDynamicTimeUpdates = (eventsStore.eventForTimeUpdates == event)
            let durationFormatter = eventDurationFormatter(forCellAtLastPosition: isCellForDynamicTimeUpdates)
            let cell = cell as! DayStartingWakeCell
            cell.typeLabel.text = "Подъем"
            cell.startTimeLabel.text = eventDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        private func configureDayFinishingSleepCell(_ cell: UITableViewCell,_ event: Event) -> () {
            let durationFormatter = eventDurationFormatter(forCellAtLastPosition: false)
            let cell = cell as! DayFinishingSleepCell
            cell.typeLabel.text = "Отбой"
            cell.timeLabel.text = eventDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        private func configureDayFillingWakeCell(_ cell: UITableViewCell,_ event: Event) -> () {
            let isCellForDynamicTimeUpdates = (eventsStore.eventForTimeUpdates == event)
            let durationFormatter = eventDurationFormatter(forCellAtLastPosition: isCellForDynamicTimeUpdates)
            let cell = cell as! DayFillingWakeCell
            cell.timeLabel.text = eventDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        private func configureDayFillingSleepCell(_ cell: UITableViewCell,_ event: Event) -> () {
            let isCellForDynamicTimeUpdates = (eventsStore.eventForTimeUpdates == event)
            let durationFormatter = eventDurationFormatter(forCellAtLastPosition: isCellForDynamicTimeUpdates)
            let cell = cell as! DayFillingSleepCell
            let num = eventsStore.numberOfSleepEventInADay(event)
            cell.typeLabel.text = "Сон номер № \(num)"
            cell.timeLabel.text = eventDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        
        private var eventDateFormatter: DateFormatter {
           let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .none
            return formatter
        }
        private func eventDurationFormatter(forCellAtLastPosition isLast: Bool) -> DateComponentsFormatter {
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
}
