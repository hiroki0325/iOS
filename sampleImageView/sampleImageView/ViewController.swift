//
//  ViewController.swift
//  sampleImageView
//
//  Created by 島田洋輝 on 2016/01/29.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapImage1(sender: UIButton) {
        myImageView.image = UIImage(named: "image.jpg")
    }
    
    @IBAction func tapImage2(sender: UIButton) {
        myImageView.image = UIImage(named: "snow.jpeg")
    }

}

