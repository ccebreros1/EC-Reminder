//
//  ListViewController.swift
//  World Explorer
//
//  Created by Cesar A Cebreros Lara on 2017-02-06.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//
//  Followed this tutorial http://sweettutos.com/2015/11/25/eventkit-reminders-manager-how-to-retrieve-create-and-edit-reminders-from-within-your-app-in-swift/ for retrieving a list of reminders from the database of the phone/tablet. Many of the code belongs to that tutorial, and some modifications were made for the purpose of this lab.

import UIKit
import EventKit

class ListViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    //This is for allowing access to reminders and calendar apps on iOS
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    //Add a var for the event that will ask for permission
    var eventStore = EKEventStore()
    var reminders: [EKReminder]!
    var titles : [String] = []
    let cellIdentifier = "reminderCell"
    @IBOutlet weak var remindersTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        remindersTable.dataSource = self
        remindersTable.delegate = self
        remindersTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        askForPermission()
        getReminders()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if (cell == nil) {
                cell = UITableViewCell(
                    style: UITableViewCellStyle.default,
                    reuseIdentifier: cellIdentifier)
            }
            cell?.textLabel?.text = titles[indexPath.row]
            return cell!
    }
    func getReminders()
    {
        let calendars =
            eventStore.calendars(for: EKEntityType.reminder)
        
        for calendar in calendars as [EKCalendar] {
            if calendar.title == "Reminders"
            {
                for reminder in reminders {
                    titles.append(reminder.title)
                }
            }
        }
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Ask for reminder permissions
    func askForPermission(){
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    let controller = UIAlertController(title: "Reminder creation failed", message: "Access to reminders not granted", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                    controller.addAction(cancelAction)
                    self.present(controller, animated: true, completion: nil)
                }
        })
        
    }
}
