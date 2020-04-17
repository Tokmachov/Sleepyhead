//
//  PersistaneManager.swift
//  Sleepyhead
//
//  Created by mac on 15/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData

struct EventsPersistenceService {
    static private var appDelegate: AppDelegate {
        guard  let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            fatalError(AppDelegateIsNotAvailable().errorDescription!)
        }
        return appDelegate
    }
    static var managedObjectContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    static func saveContext() {
        appDelegate.saveContext()
    }
}

extension EventsPersistenceService {
    struct AppDelegateIsNotAvailable: LocalizedError {
        var errorDescription: String? {
            return "Data saving error: AppDelegate is not available"
        }
    }
}
