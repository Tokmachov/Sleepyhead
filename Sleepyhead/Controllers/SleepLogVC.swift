//
//  ViewController.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SleepLogVC: UITableViewController {
    
    private var eventsStorage: EventsStorage!
    private var lastEntryDurationUpdateTimer: Timer?
    private var lastIndexPath: IndexPath {
        return IndexPath(row: eventsStorage.events.count - 1, section: 0)
    }
    
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
        eventsStorage = EventsStorage(events: events)
        setLastEntryDurationUpdateTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastEntryDurationUpdateTimer?.invalidate()
    }
}

extension SleepLogVC {
    
}

extension SleepLogVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsStorage.events.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventIndex = indexPath.row
        let event = eventsStorage.events[eventIndex]
        let cell: UITableViewCell
        switch event.type {
        case .goToSleepTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "BedTimeCell", for: indexPath)
        
        case .wakeTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "WakeTimeCell", for: indexPath)

        }
        configureCell(cell, with: event)
        return cell
    }
}

extension SleepLogVC {
    private var entryDateFormatter: DateFormatter {
       let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter
    }
    private func entryDurationFormatter(forCellAtPosition isLast: Bool) -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        if isLast {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.hour, .minute]
        }
        return formatter
    }
    private func configureCell(_ cell: UITableViewCell, with event: Event) {
        let startTime = entryDateFormatter.string(from: event.startDate)
        let isLast = (eventsStorage.events.last == event)
        let duration = eventsStorage.duration(of: event)!
        let formatter = entryDurationFormatter(forCellAtPosition: isLast)
        let durationFormatted = formatter.string(from: duration)
        cell.textLabel?.text = startTime
        cell.detailTextLabel?.text = durationFormatted
        if isLast {
            cell.detailTextLabel?.text! += " \u{023F1}"
        }
    }
    private func setLastEntryDurationUpdateTimer() {
        lastEntryDurationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [self.lastIndexPath], with: .fade)
        }
    }

}
