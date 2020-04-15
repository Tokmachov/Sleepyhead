//
//  ViewController.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SleepLogVC: UITableViewController {
    
    private var entriesStorage = EntriesStorage()
    private var lastEntryDurationUpdateTimer: Timer?
    private var lastIndexPath: IndexPath {
        return IndexPath(row: entriesStorage.entries.count - 1, section: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        printEntries(entriesStorage.entries)
        setLastEntryDurationUpdateTimer()
    }
}

extension SleepLogVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entriesStorage.entries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entryIndex = indexPath.row
        let entry = entriesStorage.entries[entryIndex]
        let cell: UITableViewCell
        switch entry.type {
        case .goToSleepTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "BedTimeCell", for: indexPath)
        
        case .wakeTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "WakeTimeCell", for: indexPath)

        }
        if indexPath != lastIndexPath {
            configureCell(cell, with: entry, durationFormatter: dateComponentsFormatterForEntryDurationOfNotLastCell)
        } else {
            configureCell(cell, with: entry, durationFormatter: dateComponentsFormatterForEntryDorationOfLastCell)
        }
        return cell
    }
}

extension SleepLogVC {
    private var dateFormatter: DateFormatter {
       let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        return formatter
    }
    private var dateComponentsFormatterForEntryDurationOfNotLastCell: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter
    }
    private var dateComponentsFormatterForEntryDorationOfLastCell: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        return formatter
    }
    private func configureCell(_ cell: UITableViewCell, with entry: Entry, durationFormatter: DateComponentsFormatter) {
        let startTime = dateFormatter.string(from: entry.startDate)
        guard let duration = entriesStorage.duration(of: entry) else { fatalError("unable to produce entry duration") }
        let durationFormatted = durationFormatter.string(from: duration)
        cell.textLabel?.text = startTime
        cell.detailTextLabel?.text = durationFormatted
    }
    
    private func setLastEntryDurationUpdateTimer() {
        lastEntryDurationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [self.lastIndexPath], with: .fade)
        }
    }

}
