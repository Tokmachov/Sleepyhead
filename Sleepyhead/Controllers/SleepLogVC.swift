//
//  ViewController.swift
//  Sleepyhead
//
//  Created by mac on 11/04/2020.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class SleepLogVC: UITableViewController {
    
    private  var entries = [Entry]()
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = EntriesFactory.makeEntries(numberOfDays: 2)
        printEntries(entries)
    }
}

