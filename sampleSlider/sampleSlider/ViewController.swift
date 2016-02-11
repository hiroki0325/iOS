//
//  ViewController.swift
//  sampleSlider
//
//  Created by 島田洋輝 on 2016/01/27.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = "音量最適"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
//        print(sender.value)
        myLabel.text = NSString(format: "%.2F", sender.value) as String
        if sender.value <= 0.5{
            print("音が小さいです")
        } else {
            print("音が大きいです")
        }
    }

}

