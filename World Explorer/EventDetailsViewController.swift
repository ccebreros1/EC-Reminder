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
    var tableViewCell:TableViewCellViewController? = nil
    let dateCellIdentifier = "dateDueCell"
    //var reminderUrl : URL!
    @IBOutlet weak var detailsTable: UITableView!
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToList", sender: self)

    }
    
    @IBOutlet weak var titleLabel: UILabel!
    var eventId: String!
    var remindersUrl = "x-apple-reminder://"
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCell? = TableViewCellViewController()
        titleLabel.text = reminderTitle
        tableViewCell?.datePicker.date = (reminder.dueDateComponents?.date)!
        tableViewCell?.locationLabel.text = reminder.location
        //dateCellIdentifier.isHidden = true;
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        detailsTable.dataSource = self
        detailsTable.delegate = self
        detailsTable.register(UITableViewCell.self, forCellReuseIdentifier: dateCellIdentifier)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Get the number of total rows that the table view should create
        return 3
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            //Create a cell
            var cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier)
            if (cell == nil) {
                cell = UITableViewCell(
                    style: UITableViewCellStyle.default,
                    reuseIdentifier: dateCellIdentifier)
            }
            //Add the label of the row
            cell?.accessoryType = .detailButton
            cell?.textLabel?.text = "Hello"
            //Return a cell that was created
            return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        if indexPath.section == 0
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier)
            cell1?.isHidden = false
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    //END OF SECTION FOR METHODS RELATED TO TABLE VIEW


}
