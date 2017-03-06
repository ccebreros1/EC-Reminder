//
//  ListViewController.swift
//  EC Reminder
//
//  Created by Cesar A Cebreros Lara on 2017-02-06.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//
//  Followed this tutorial http://sweettutos.com/2015/11/25/eventkit-reminders-manager-how-to-retrieve-create-and-edit-reminders-from-within-your-app-in-swift/ for retrieving a list of reminders from the database of the phone/tablet. Many of the code belongs to that tutorial, and some modifications were made for the purpose of this lab.
// Also got ideas from https://github.com/keith/reminders-cli/blob/master/Sources/Reminders.swift and many forums of StackOverflow for understanding of methods and functions

import UIKit
import EventKit

class ListViewController:UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    //This is for allowing access to reminders and calendar apps on iOS
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    //Add a var for the event that will ask for permission
    let eventStore = EKEventStore()
    //Create a variable for an array of reminders
    var reminders: [EKReminder]!
    //Create a varaible for an array of titles
    var titles : [String] = []
    //Create a constant for a cell identifiker of the table view
    let cellIdentifier = "reminderCell"
    //Outlet for the table view
    @IBOutlet weak var remindersTable: UITableView!
    
    //SegueIdentifier
    let detailsSegueIdentifier = "showEventDetailsSegue"
    let newReminderSegueIdentifier = "newReminderSegue"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ask for permission
        askForPermission()
        // Do any additional setup after loading the view.
        remindersTable.dataSource = self
        remindersTable.delegate = self
        remindersTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
    }
    
    //This overrides when the view appears so that it re-loads without the need of closing and re-opening the app
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Load the reminders in the local database of the device
        getReminders()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Ask for reminder permissions`
    func askForPermission() -> Void{
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
    
    //SECTION FOR METHODS RELATED TO TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Get the number of total rows that the table view should create
        return titles.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            //Create a cell
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if (cell == nil) {
                cell = UITableViewCell(
                    style: UITableViewCellStyle.default,
                    reuseIdentifier: cellIdentifier)
            }
            //Add the label of the row
            cell?.textLabel?.text = titles[indexPath.row]
            cell?.imageView?.image = UIImage(named: "bookmark-symbol")
            cell?.accessoryType = .disclosureIndicator
            //Return a cell that was created
            return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        //Change screen to the details view
        performSegue(withIdentifier: detailsSegueIdentifier, sender: cell)
    }

    
    //END OF SECTION FOR METHODS RELATED TO TABLE VIEW
    
    //Get all reminders
    func getReminders()
    {
        //String for a calendar unique ID
        var calUID:String! = "?"
        //Get the reminders calendars array
        let cal =  eventStore.calendars(for: EKEntityType.reminder) as [EKCalendar]
        //Loop through the calendars to get the calendar identifier ID
        for i in cal {
            if i.title == "Reminders" {
                //Set the calendar unique ID to the one that was retrieved from the loop
                calUID = i.calendarIdentifier
            }
        }
        //Create a new instance of the reminders calendar
        let reminder = eventStore.calendar(withIdentifier: calUID!)

        //Clear the array to avoid duplicated reminders
        self.titles.removeAll()
        
        //Get all reminders using the menthod created
        self.getAllReminders(onCalendar: reminder!){ reminders1 in
            //Loop through the whole reminders array to get the title of each one
            for (_, reminder) in reminders1.enumerated()
            {
                //add the title to the array of titles
                self.titles.append(reminder.title)
            }
            //Re-load the table view
            DispatchQueue.main.async{
                //Check for no reminders in device
                if self.titles.count == 0
                {
                    let controller = UIAlertController(title: "No reminders available", message: "There are no reminders on your phone, please set up a reminder first", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: {(action:UIAlertAction!)-> Void in self.performSegue(withIdentifier: self.newReminderSegueIdentifier, sender: self)})
                    controller.addAction(cancelAction)
                    self.present(controller, animated: true, completion: nil)
                    
                }
                //There are reminders in device
                else
                {
                    self.remindersTable.reloadData()
                }
            }
        }
    }
    //Prepare for segue to change screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) -> Void {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == detailsSegueIdentifier
        {
            let indexPath = remindersTable.indexPath(for: sender as! UITableViewCell)!
            let detailsVC = segue.destination as! EventDetailsViewController
            let title = titles[indexPath.row]
            detailsVC.reminderTitle = title
        }
    }
    
    @IBAction func unwindToMenu(_ segue: UIStoryboardSegue) {}
    
    //Private Functions
    
    private func getAllReminders(onCalendar calendar: EKCalendar, completion: @escaping (_ reminders: [EKReminder]) -> Void)
    {
        let predicate = eventStore.predicateForReminders(in: [calendar])
        
        eventStore.fetchReminders(matching: predicate) {reminders in
            let reminders1 = reminders?
                .filter{!$0.isCompleted}
                .sorted{($0.creationDate ?? Date.distantPast) < ($1.creationDate ?? Date.distantPast)}
            completion(reminders1 ?? [])
            //Debugging only
            print(String(describing: reminders1))
        }
        
    }
    

    
    private func getCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .reminder)
            .filter { $0.allowsContentModifications }
    }
    
    
}
