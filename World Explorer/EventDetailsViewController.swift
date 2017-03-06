//
//  EventDetailsViewController.swift
//  EC Reminder
//
//  Created by Cesar A Cebreros Lara on 2017-02-13.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsViewController: UIViewController {
    
    var datePicker: UIDatePicker!
    var reminder: EKReminder!
    var eventStore: EKEventStore!
    var reminderTitle: String?
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToList", sender: self)

    }
    
    @IBOutlet weak var titleLabel: UILabel!
    var eventId: String!
    var remindersUrl = "x-apple-reminder://"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = reminderTitle
        //var remiderUrl = NSURL(remindersUrl += eventId)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //@IBAction func viewInRemindersApp(_ sender: UIButton) {
        //UIApplication.shared.open(reminderUrl, options: [:], completionHandler: nil)
    //}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
