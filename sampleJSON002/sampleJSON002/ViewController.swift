//
//  ViewController.swift
//  sampleJSON002
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
    
    override func viewWillAppear(animated: Bool) {
        // json.txtファイルを読み込んで
        var path = NSBundle.mainBundle().pathForResource("json", ofType: "txt")
        var jsondata = NSData(contentsOfFile: path!)
        
        // 配列データに変換して
        let jsonArray = try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: []) as! NSArray
        
        // 配列の個数だけ繰り返して表示する
        for dat in jsonArray {
            var d1 = dat["name"] as! String
            var d2 = dat["price"] as! Int
            print("name[\(d1)] price[\(d2)]")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

