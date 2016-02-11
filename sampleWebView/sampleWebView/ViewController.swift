//
//  ViewController.swift
//  sampleWebView
//
//  Created by 島田洋輝 on 2016/02/01.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myURL = NSURL(string: "http://www.yahoo.co.jp/")
        var myURLReq = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLReq)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

