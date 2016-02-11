//
//  ViewController.swift
//  homeworkJSON
//
//  Created by 島田洋輝 on 2016/02/03.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var year:String = ""
    var month:String = ""
    var day:String = ""
    
    @IBOutlet weak var myDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        myDatePicker.maximumDate = NSDate()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setDate(sender: UIDatePicker) {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-M-d"
        var strDate = df.stringFromDate(sender.date)
        var date = strDate.componentsSeparatedByString("-")
        self.year = date[0]
        self.month = date[1]
        self.day = date[2]
    }
    
    @IBAction func tapBtn(sender: UIButton) {
        var url = "http://tepco-usage-api.appspot.com/\(year)/\(month)/\(day)/0.json"
        var URL = NSURL(string: url)
        var request = NSURLRequest(URL: URL!)
        var jsondata = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        var jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(jsondata, options: []) as! NSDictionary

        for (key, data) in jsonDictionary {
            print("\(key):\(data)")
        }
    }
    


}

