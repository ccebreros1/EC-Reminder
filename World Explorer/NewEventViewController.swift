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
import LocalAuthentication //For fingerprint

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
    //fingerprint stuff
    var context = LAContext()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        askForPermission()
        determineCurrentLocation()
    }
    
    func applicationWillEnterForeground(notification:NSNotification) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        checkCredentials()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        checkCredentials()
    }
    
    //This overrides when the view appears so that it re-loads without the need of closing and re-opening the app
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        defaults.synchronize()
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(notification:)), name: Notification.Name.UIApplicationWillEnterForeground, object: app)
        checkCredentials()
    }
    //Check that the username and password are right
    //Username: admin
    //Password: Pa$$word1
    func checkCredentials() -> Void
    {
        print("reached permission check")
        let defaults = UserDefaults.standard
        let userNamekey = "username_preference"
        let passwordKey = "password_preference"
        let fingerprintKey = "fingerprint_preference"
        
        let userName = defaults.object(forKey: userNamekey) as? String
        let password = defaults.object(forKey: passwordKey) as? String
        
        //api
        let loginUrl = "https://www.cesarcebreros.com/api/MobileController/"

        //Determine if credentials are right
        if let url = URL(string: loginUrl + userName! + "/" + password!) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                guard error == nil else {
                    print(error!)
                    return
                }
                if let information = String(data: data!, encoding: String.Encoding.utf8) {
                    print(information)
                    if information == "true" {
                        
                        
                        DispatchQueue.main.async {
                            let controller = UIAlertController(title: "Login Succeeded", message: "The credentials are right, more features coming up...", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
                            controller.addAction(cancelAction)
                            self.present(controller, animated: true, completion: nil)                        }
                        
                        
                        print("valid login credential")
                        
                    } else {
                        DispatchQueue.main.async {
                            let controller = UIAlertController(title: "You did not enter the right credentials", message: "You need the right credentials to use this app. Please contact your system admin to get them. (Or view the source code ;). You can also use your fingerprint! or create an account on https://www.cesarcebreros.com/account/register to try my API!)", preferredStyle: .alert)
                            let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(action:UIAlertAction!)-> Void in self.openSettingsApp()})
                            controller.addAction(settingsAction)
                            self.present(controller, animated: true, completion: nil)
                            defaults.set("", forKey: userNamekey)
                            defaults.set("", forKey: passwordKey)
                        }
                        print("invalid login credential")
                    }
                }
            }
            task.resume()
            
        }

        
        //fingerprint is not used
        //if(userName != "admin" &&  password != "Pa$$word1" && defaults.object(forKey: fingerprintKey) as? Bool != true)
        //{
        //}
        //fingerprint is used (MOCK AUTHENTICATION. CAN DEVELOP FURTHER)
        if(defaults.object(forKey: fingerprintKey) as? Bool == true && defaults.object(forKey: userNamekey) as? String == "" && defaults.object(forKey: passwordKey) as? String == "")
        {
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            defaults.set("me@cesarcebreros.com", forKey: userNamekey)
                            defaults.set("Te$ter1", forKey: passwordKey)
                        } else {
                            let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }

    }
    
    func openSettingsApp() -> Void
    {
        let application = UIApplication.shared
        let url = URL(string: UIApplicationOpenSettingsURLString)! as URL
        if application.canOpenURL(url)
        {
            application.open(url, options: ["" : ""], completionHandler: nil)
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
