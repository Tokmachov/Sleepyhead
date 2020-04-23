//
//  ViewController.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class EventLogVC: UITableViewController {
    var eventsStore: EventsStore! {
        didSet {
            tableView.reloadData()
        }
    }
    private var lastEntryDurationUpdateTimer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let type = cellType(for: event.type, atPosition: eventPositionInDay)
        let cell = tableView.dequeueReusableCell(withIdentifier: type.rawValue, for: indexPath)
        let factory = CellConfiguratorFactory(eventStore: eventsStore)
        let configureFucntion = factory.make(cellType: type)
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
    private func cellType(for eventType: EventType, atPosition position: PositionOfEventInADay) -> CellType {
        switch (eventType, position) {
        case (.wakeTime, .dayStarting): return .dayStartingWakeCell
        case (.sleepTime, .dayFinishing): return .dayFinishingSleepCell
        case (.wakeTime, _): return .dayFillingWakeCell
        case (.sleepTime, _): return .dayFillingSleepCell
        }
    }
    enum CellType: String {
        case dayStartingWakeCell = "DayStartingCell"
        case dayFillingWakeCell = "DayFillingWakeCell"
        case dayFillingSleepCell = "DayFillingSleepCell"
        case dayFinishingSleepCell = "DayFinishingSleepCell"
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
        func make(cellType: CellType) -> ((UITableViewCell, Event) -> ()) {
            switch cellType {
            case .dayStartingWakeCell: return configureDayStartingWakeCell(_:_:)
            case .dayFillingWakeCell: return configureDayFillingWakeCell(_:_:)
            case .dayFillingSleepCell:  return configureDayFillingSleepCell(_:_:)
            case .dayFinishingSleepCell:  return configureDayFinishingSleepCell(_:_:)
            }
        }
        private func configureDayStartingWakeCell(_ cell: UITableViewCell, _ event: Event) -> () {
            let isCellForDynamicTimeUpdates = (eventsStore.eventForTimeUpdates == event)
            let durationFormatter = DateFormatters.eventDurationFormatter(forCellAtLastPosition: isCellForDynamicTimeUpdates)
            let cell = cell as! DayStartingWakeCell
            cell.typeLabel.text = "Подъем"
            cell.startTimeLabel.text = DateFormatters.eventStartDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        private func configureDayFinishingSleepCell(_ cell: UITableViewCell,_ event: Event) -> () {
            let durationFormatter = DateFormatters.eventDurationFormatter(forCellAtLastPosition: false)
            let cell = cell as! DayFinishingSleepCell
            cell.typeLabel.text = "Отбой"
            cell.timeLabel.text = DateFormatters.eventStartDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        private func configureDayFillingWakeCell(_ cell: UITableViewCell,_ event: Event) -> () {
            let isCellForDynamicTimeUpdates = (eventsStore.eventForTimeUpdates == event)
            let durationFormatter = DateFormatters.eventDurationFormatter(forCellAtLastPosition: isCellForDynamicTimeUpdates)
            let cell = cell as! DayFillingWakeCell
            cell.timeLabel.text = DateFormatters.eventStartDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
        private func configureDayFillingSleepCell(_ cell: UITableViewCell,_ event: Event) -> () {
            let isCellForDynamicTimeUpdates = (eventsStore.eventForTimeUpdates == event)
            let durationFormatter = DateFormatters.eventDurationFormatter(forCellAtLastPosition: isCellForDynamicTimeUpdates)
            let cell = cell as! DayFillingSleepCell
            let num = eventsStore.numberOfSleepEventInADay(event)
            cell.typeLabel.text = "Сон номер № \(num)"
            cell.timeLabel.text = DateFormatters.eventStartDateFormatter.string(from: event.startDate)
            cell.durationLabel.text = durationFormatter.string(from: eventsStore.duration(of: event))
        }
    }
}
