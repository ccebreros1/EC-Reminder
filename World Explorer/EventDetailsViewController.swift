//
//  EventDetailsViewController.swift
//  EC Reminder
//
//  Created by Cesar A Cebreros Lara on 2017-02-13.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//
//The expandable table view was done taking pieces of code from http://www.appcoda.com/expandable-table-view/
// Added some functionality from the book

import UIKit
import EventKit
import Foundation

class EventDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var datePicker: UIDatePicker!
    var reminder: EKReminder!
    var eventStore: EKEventStore!
    var reminderTitle: String?
    //var tableViewCell:TableViewCellViewController? = nil
    let dateDueCellIdentifier = "dateDueCell"
    let datePickerCellIdentifier = "datePickerCell"
    let locationCellIdentifier = "locationCell"
    
    var datePicker1 = TableViewCellViewController.sharingInstance.datePicker
    var dateLabel1 = TableViewCellViewController.sharingInstance.dateLabel
    var locationLabel1 = TableViewCellViewController.sharingInstance.locationLabel
    
    //URL For oppening reminders app
    @IBOutlet weak var titleLabel: UILabel!
    var eventId: String!
    var remindersUrl = "x-apple-reminder://"
    
    @IBOutlet weak var detailsTable: UITableView!
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToList", sender: self)

    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = reminder.title

        // Do any additional setup after loading the view.
        let datePickerNib = UINib(nibName: "DatePickerCell", bundle: nil)
        let dateDueNib = UINib(nibName: "dateDueCell", bundle: nil)
        let locationNib = UINib(nibName: "locationCell", bundle: nil)
        detailsTable.dataSource = self
        detailsTable.delegate = self
        detailsTable.register(dateDueNib, forCellReuseIdentifier: dateDueCellIdentifier)
        detailsTable.register(datePickerNib, forCellReuseIdentifier: datePickerCellIdentifier)
        detailsTable.register(locationNib, forCellReuseIdentifier: locationCellIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Educational purposes. This button will go away if the app is published in Appstore since it interferes with apple's policies using undocumented URLStrings
    @IBAction func viewInRemindersApp(_ sender: UIButton) {
        let concatenation : String = remindersUrl + eventId
        let stringUrl: NSString = concatenation as NSString
        let reminderURL = URL(string: stringUrl as String)
        UIApplication.shared.open(reminderURL!, options: [:], completionHandler: nil)
    }
    
    //SECTION FOR METHODS RELATED TO TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Get the number of total rows that the table view should create
        return 3
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            //Create a cell
            if indexPath.row == 0
            {
                //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: dateDueCellIdentifier)
                let cell1 = tableView.dequeueReusableCell(withIdentifier: dateDueCellIdentifier) as! TableViewCellViewController
                cell1.accessoryType = .detailButton
                let datevalue = reminder.dueDateComponents?.date!
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .medium
                
                let dateLabelTextF = dateFormatter.string(from: datevalue!)
                cell1.dateLabel.text = dateLabelTextF
            
            //cell1?.
            //Return a cell that was created
            return cell1
            }
            else if indexPath.row == 1 {
                //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: datePickerCellIdentifier)
                let cell1 = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier)as! TableViewCellViewController
                cell1.isHidden = true
                cell1.datePicker.date = (reminder.dueDateComponents?.date)!
            
                
                //set the data here
                return cell1
            }
            else {
                //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: locationCellIdentifier)
                let cell1 = tableView.dequeueReusableCell(withIdentifier: locationCellIdentifier) as! TableViewCellViewController
                cell1.locationLabel.text = reminder.location
                
                //set the data here
                return cell1
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            //cell2?.isHidden = false
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    //END OF SECTION FOR METHODS RELATED TO TABLE VIEW


}
