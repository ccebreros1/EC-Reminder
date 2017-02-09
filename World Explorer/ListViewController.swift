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
    let eventStore = EKEventStore()
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
        self.getReminders()
        
    }
    
    override func didReceiveMemoryWarning()
    {
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
        let reminder =
            eventStore.calendars(for: .reminder).first?.calendarIdentifier
        
        let reminders = eventStore.calendar(withIdentifier: reminder!)
        
        if let remindersUnwrapped = reminders, let reminderUnwrapped = reminder
        {
        
        self.getAllReminders(onCalendar: remindersUnwrapped){ reminders1 in
            for (i, reminderUnwrapped) in self.reminders.enumerated()
            {
                self.titles.append(reminderUnwrapped.title)
            }
        
        }
        }
    }
    
    //Private Functions
    
    private func getAllReminders(onCalendar calendar: EKCalendar, completion: @escaping (_ reminders: [EKReminder]) -> Void)
    {
        let predicate = eventStore.predicateForReminders(in: [calendar])
        
        eventStore.fetchReminders(matching: predicate) {reminders in
            let reminders1 = reminders?
                .filter{!$0.isCompleted}
                .sorted{($0.creationDate ?? Date.distantPast) < ($1.creationDate ?? Date.distantPast)}
            completion(reminders1 ?? [])
        }
        
    }
    

    
    private func getCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .reminder)
            .filter { $0.allowsContentModifications }
    }
    
    
}
