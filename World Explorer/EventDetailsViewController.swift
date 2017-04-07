//
//  EventDetailsViewController.swift
//  EC Reminder
//
//  Created by Cesar A Cebreros Lara on 2017-02-13.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//
//The expandable table view was done taking pieces of code from http://www.appcoda.com/expandable-table-view/
// Added some functionality from the book
//For image display and save this tutorials were used:
//https://github.com/brianadvent/PresentApp/blob/master/PresentBase/ChristmasPresentsTableViewController.swift
//https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift

import UIKit
import EventKit
import Foundation
import MapKit
import CoreData

class EventDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //Reminders stuff
    var reminder: EKReminder!
    var eventStore: EKEventStore!
    var reminderTitle: String?
    //This is for allowing access to reminders and calendar apps on iOS
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    
    // moc
    var managedObjextContext : NSManagedObjectContext?
    
    //Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminderImage: UIImageView!
    //@IBOutlet weak var map: MKMapView!
    
    
    //Maps stuff
     //var locationManager:CLLocationManager!
    
    
    
    //URL For oppening reminders app
    //var remindersUrl = "x-apple-reminder://"
    var eventId: String!
 
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToList", sender: self)

    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
   /* @IBAction func viewInRemindersApp(_ sender: UIButton) {
        let concatenation : String = remindersUrl + eventId
        let stringUrl: NSString = concatenation as NSString
        let reminderURL = URL(string: stringUrl as String)
        UIApplication.shared.open(reminderURL!, options: [:], completionHandler: nil)
    }*/
 
    @IBAction func saveChanges(_ sender: UIButton)
    {
        
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
    
    //MARK: Camera and Gallery stuff for picking an image
    
    //Open the gallery
    @IBAction func openGallery(_ sender: UIButton)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //Open the camera
    @IBAction func openCamera(_ sender: UIButton)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Delegate for when the image finished being picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        reminderImage.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    
    //Save the image to the core data
    func saveImage(imageData:NSData, name: String)
    {
        
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
