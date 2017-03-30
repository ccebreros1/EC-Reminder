//
//  TabBarViewController.swift
//  EC Reminder
//
//  Created by Cesar A Cebreros Lara on 2017-03-27.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkCredentials()
        
        // Do any additional setup after loading the view.
    }
    
    //This overrides when the view appears so that it re-loads without the need of closing and re-opening the app
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        checkCredentials()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Check that the username and password are right
    //Username: admin
    //Password: Pa$$word1
    func checkCredentials() -> Void
    {
        let defaults = UserDefaults.standard
        let userNamekey = "username_preference"
        let passwordKey = "password_preference"
        
        if(defaults.object(forKey: userNamekey) as? String != "admin" && defaults.object(forKey: passwordKey) as? String != "Pa$$word1")
        {
            let controller = UIAlertController(title: "You did not enter the right credentials", message: "You need the right credentials to use this app. Please contact your system admin to get them. (Or view the source code ;))", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Open Settings", style: .default, handler: {(action:UIAlertAction!)-> Void in self.openSettingsApp()})
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
