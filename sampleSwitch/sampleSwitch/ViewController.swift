//
//  ViewController.swift
//  sampleSwitch
//
//  Created by 島田洋輝 on 2016/01/27.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = "on"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchChanged(sender: UISwitch) {
//        print(sender.on)
        if sender.on == true{
            print("スイッチon")
            myLabel.text = "on"
        } else {
            print("スイッチoff")
            myLabel.text = "off"
        }
    }

}

