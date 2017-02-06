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

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    //This is for allowing access to reminders and calendar apps on iOS
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    //Add a var for the event that will ask for permission
    var eventStore = EKEventStore()
    var reminders: [EKReminder]!
    
    @IBOutlet weak var remindersTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        askForPermission()
        remindersTable.dataSource = self
        remindersTable.delegate = self
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "reminderCell")
        let reminder:EKReminder! = self.reminders![indexPath.row]
        cell.textLabel?.text = reminder.title
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let dueDate = reminder.dueDateComponents?.date{
            cell.detailTextLabel?.text = formatter.string(from: dueDate)
        }else{
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
}
