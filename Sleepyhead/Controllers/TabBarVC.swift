//
//  TabBarVC.swift
//  Sleepyhead
//
//  Created by mac on 22/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, EventControlVCDelegate {
    private var eventControlVC: EventControlVC!
    private var eventLogVC: EventLogVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        eventControlVC.delegate = self
        let events = getEvents()
        updateEventLogVC(with: events)
        updateEventControlVC(with: events.last!)
        selectedIndex = 0
    }
    //MARK: EventControlVCDelegate
    func didCreateNewEvent(_ eventControlVc: EventControlVC) {
         let events = EventsPersistenceService.fetchAllEvents()
         updateEventLogVC(with: events)
     }
}
extension TabBarVC {
    private func setupVCs() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        eventControlVC = storyBoard.instantiateViewController(identifier: VCTitles.eventControlVC)
        eventLogVC = storyBoard.instantiateViewController(identifier: VCTitles.eventLogVC)
        setViewControllers([eventControlVC, eventLogVC], animated: true)
    }
    private func updateEventLogVC(with events: [Event]) {
        eventLogVC.eventsStore = EventsStore(events: events)
    }
    private func updateEventControlVC(with event: Event) {
        eventControlVC.event = event
    }
}

extension TabBarVC {
    private func getEvents() -> [Event] {
        var events = [Event]()
        events = EventsPersistenceService.fetchAllEvents()
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
        return events
    }
}

extension TabBarVC {
    struct VCTitles {
        static var eventControlVC = "EventControlVC"
        static var eventLogVC = "EventLogVC"
    }
}

protocol EventControlVCDelegate: AnyObject {
    func didCreateNewEvent(_ eventControlVc: EventControlVC)
}
