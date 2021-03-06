//
//  TableViewCellViewController.swift
//  EC Reminder
//
//  Created by Cesar A Cebreros Lara on 2017-03-13.
//  Copyright © 2017 Cesar A Cebreros Lara. All rights reserved.
//

import UIKit

class TableViewCellViewController: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationLabel: UILabel!
    
    static let sharingInstance = TableViewCellViewController()
    
    @IBOutlet weak var HeightConstraint: NSLayoutConstraint!
    
    
    var isExpanded:Bool = false
        {
        didSet
        {
            if !isExpanded {
                self.HeightConstraint.constant = 0.0
                
            } else {
                self.HeightConstraint.constant = 128.0
            }
        }
    }

    
}
