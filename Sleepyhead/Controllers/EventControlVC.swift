//
//  EventControlVC.swift
//  Sleepyhead
//
//  Created by mac on 22/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class EventControlVC: UIViewController {
    var event: Event! {
        didSet {
            updateEventLabels()
            setButtonsAppearence()
        }
    }
    private var durationUpdater: Timer?
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var newEventButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        durationUpdater?.invalidate()
        setDurationUpdater()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        durationUpdater?.invalidate()
    }
    @IBAction func newEventButtonWasPressed() {
        let event = createNewEvent()
        self.event = event
    }
}

extension EventControlVC {
    //MARK: Event labels
    private func updateEventLabels() {
        typeLabel.text = nameOfEventType(for: event.type)
        startDateLabel.text = DateFormatters.eventStartDateFormatter.string(from: event.startDate)
    }
    private func updateEventDuration() {
        let formatter = DateFormatters.eventDurationFormatter(forCellAtLastPosition: true)
        let eventDuration = event.startDate.distance(to: Date())
        durationLabel.text = formatter.string(from: eventDuration)
    }
    private func setDurationUpdater() {
        durationUpdater = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
        guard let self = self else { return }
        self.updateEventDuration()
        })
    }
    private func nameOfEventType(for type: EventType) -> String {
        switch type {
        case .sleepTime: return "Сон"
        case .wakeTime: return "Пробуждение"
        }
    }
    
    //MARK: Button's appearance
    private func setButtonsAppearence() {
        newEventButton.layer.cornerRadius = newEventButton.frame.height / 2
        newEventButton.backgroundColor = EventControlVCColors.buttonColor(for: event.type)
        let buttonTitle = titleForNewEventButton(from: event.type)
        newEventButton.setTitle(buttonTitle, for: .normal)
    }
    private func titleForNewEventButton(from currentType: EventType) -> String {
        switch currentType {
        case .sleepTime: return "Проснуться"
        case .wakeTime: return "Заснуть"
        }
    }
}

extension EventControlVC {
    private func createNewEvent() -> Event {
        let type = newEventType(forCurrentEventType: event.type)
        let date = Date()
        let event = Event(context: EventsPersistenceService.managedObjectContext)
        event.type = type
        event.startDate = date
        EventsPersistenceService.saveContext()
        return event
    }
    private func newEventType(forCurrentEventType type: EventType) -> EventType {
        switch type {
        case .sleepTime: return .wakeTime
        case .wakeTime: return .sleepTime
        }
    }
}
