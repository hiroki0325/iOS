//
//  ViewController.swift
//  samplePList
//
//  Created by 島田洋輝 on 2016/02/11.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ファイルのパスを取得
        var filePath = NSBundle.mainBundle().pathForResource("friendsList", ofType: "plist")
        
        // ファイルの内容を読み込んで、ディクショナリー型の変数に代入
        var dic = NSDictionary(contentsOfFile: filePath!)
        
        // 名前を表示
        for(key,data) in dic!{
            print(key)
            
            var gender = data["gender"] as! String
            print(gender)
            var hobby = data["hobby"] as! String
            print(hobby)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

