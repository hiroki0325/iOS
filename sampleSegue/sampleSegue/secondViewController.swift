//
//  secondViewController.swift
//  sampleSegue
//
//  Created by 島田洋輝 on 2016/02/03.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    
    // 受け取り用の変数
    var tmpCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("次の画面が表示された時<\(tmpCount)>")
    }
    

}
