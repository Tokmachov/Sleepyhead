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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lastEntryDurationUpdateTimer?.invalidate()
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
        configureCell(cell, with: entry)
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
    private func configureCell(_ cell: UITableViewCell, with entry: Event) {
        let startTime = entryDateFormatter.string(from: entry.startDate)
        let isLast = (entriesStorage.entries.last == entry)
        let duration = entriesStorage.duration(of: entry)!
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
