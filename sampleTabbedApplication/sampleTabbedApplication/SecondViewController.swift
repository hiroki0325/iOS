//
//  SecondViewController.swift
//  sampleTabbedApplication
//
//  Created by 島田洋輝 on 2016/02/04.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // 画面が表示された時
    override func viewWillAppear(animated: Bool) {

        // AppDelegateにアクセスするための準備をして
        var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // プロパティの値を書き換える
        myAp.myCount++
        
        // プロパティの値を読みだす
        print("2画面目 count=\(myAp.myCount)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

