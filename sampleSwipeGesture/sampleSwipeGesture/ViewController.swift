//
//  ViewController.swift
//  sampleSwipeGesture
//
//  Created by 島田洋輝 on 2016/02/02.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func swipeView(sender: UISwipeGestureRecognizer) {
        print("右スワイプされた")
    }

    @IBAction func swipePinkView(sender: UISwipeGestureRecognizer) {
        print("下スワイプされた")
    }
    
    @IBAction func swipeBlueView(sender: UISwipeGestureRecognizer) {
        print("上スワイプされた")
    }
}
