//
//  SummaryViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController!.selectedIndex = 1
        // 上記だけでOKっぽいが、後で不具合が生じた時のために下記も残しておく //
        //let vc = self.tabBarController!.viewControllers![1]
        //self.tabBarController!.selectedViewController = vc
        
        //↓動かない…//
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新規作成", style: UIBarButtonItemStyle.Plain, target: self, action: "newTravel")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
