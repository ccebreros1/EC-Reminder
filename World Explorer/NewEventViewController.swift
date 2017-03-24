//
//  NewEventViewController.swift
//  World Explorer
//
//  Created by Cesar A Cebreros Lara on 2017-02-06.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//

import UIKit
import EventKit
import MapKit

class NewEventViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var reminderText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var onlyOnThisLocation: UISwitch!
    //This is for allowing access to reminders and calendar apps on iOS
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    //Add a var for the event that will ask for permission
    var eventStore = EKEventStore()
    // This is for the location
    //Maps stuff
    var locationManager:CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        askForPermission()
        determineCurrentLocation()
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
    
    //Set a reminder
    @IBAction func setReminder(_ sender: UIButton) {
        
        //If the permission is not granted yet will do this and ask for it
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion: {(granted, error) in
                    if !granted {
                        self.askForPermission()
                    }
            })
        }
        
        if (appDelegate.eventStore != nil) {
            self.createReminder()
        }
    }
    
    //Close the Keyboard
    @IBAction func onTapGestureRecognized(_ sender: Any) {
        reminderText.resignFirstResponder()
    }
    
    //Create a reminder and commit the transaction
    func createReminder() {
        
        let reminderTitle = reminderText.text!
        
        let reminder = EKReminder(eventStore: appDelegate.eventStore!)
        
        reminder.title = reminderTitle
        reminder.calendar =
            appDelegate.eventStore!.defaultCalendarForNewReminders()
        let date = datePicker.date
        //let alarmDate = datePicker.date.addingTimeInterval(60)
        let alarm = EKAlarm(absoluteDate: date)
        let components = appDelegate.dateComponentFromNSDate(date: date as NSDate)
        reminder.dueDateComponents = components as DateComponents
        reminder.addAlarm(alarm)
        print (String(describing: components))
        do {
            try appDelegate.eventStore?.save(reminder,
                                             commit: true)
            if onlyOnThisLocation.isOn
            {
                let controller = UIAlertController(title: "Upcoming feature", message: "the reminder \(reminderTitle) would be created just for this location in the future. Now was created just using the time constraints", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                controller.addAction(cancelAction)
                present(controller, animated: true, completion: nil)
            }
            else
            {
                let controller = UIAlertController(title: "Reminder added", message: "the reminder \(reminderTitle) was created", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                controller.addAction(cancelAction)
                present(controller, animated: true, completion: nil)
                
            }
            
            
        } catch let error {
            let controller = UIAlertController(title: "Reminder creation failed", message: "Reminder failed with error \(error.localizedDescription)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
    }
    
    //Location 
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }


}
