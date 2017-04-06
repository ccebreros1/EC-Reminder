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
import MapKit

class EventDetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    //Reminders stuff
    var reminder: EKReminder!
    var eventStore: EKEventStore!
    var reminderTitle: String?
    //This is for allowing access to reminders and calendar apps on iOS
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    //Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    //@IBOutlet weak var map: MKMapView!
    
    //Maps stuff
     //var locationManager:CLLocationManager!
    
    //URL For oppening reminders app
    @IBOutlet weak var titleLabel: UILabel!
    var eventId: String!
    var remindersUrl = "x-apple-reminder://"
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToList", sender: self)

    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*if(reminder.location?.isEmpty)!
        {
            determineCurrentLocation()
        }*/
        datePicker.date = (reminder.dueDateComponents?.date)!
        titleLabel.text = reminder.title
        print(reminder.calendarItemIdentifier)
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
    
    @IBAction func saveChanges(_ sender: UIButton) {
        
        let date = datePicker.date
        let alarm = EKAlarm(absoluteDate: date)
        let components = appDelegate.dateComponentFromNSDate(date: date as NSDate)
        do {
            reminder.dueDateComponents = components as DateComponents
            reminder.addAlarm(alarm)
            try eventStore.save(reminder, commit: true)
            self.reloadInputViews()
            print(String(describing: reminder))
        }catch{
            print("Error saving reminder : \(error)")
        }
        
    }
    
    /*
    //Map stuff
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Remind on"
        map.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
 */



}
