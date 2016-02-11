//
//  ViewController.swift
//  sampleDatePicker
//
//  Created by 島田洋輝 on 2016/01/28.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.datePickerMode = UIDatePickerMode.Date
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        myDatePicker.date = df.dateFromString("2015/01/01")!
        myDatePicker.minimumDate = df.dateFromString("2015/01/01")
        myDatePicker.maximumDate = df.dateFromString("2016/12/31")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
