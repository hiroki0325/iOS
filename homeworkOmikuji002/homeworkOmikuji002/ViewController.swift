//
//  ViewController.swift
//  homeworkOmikuji002
//
//  Created by 島田洋輝 on 2016/02/04.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var df = NSDateFormatter()
    var date:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        df.dateFormat = "M月d日の運勢"
        date = df.stringFromDate(NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func myDatePicker(sender: UIDatePicker) {
        self.date = df.stringFromDate(sender.date)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var newVC = segue.destinationViewController as! SecondViewController
        newVC.selectedDate = date
    }

}

