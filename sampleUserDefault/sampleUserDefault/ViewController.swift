//
//  ViewController.swift
//  sampleUserDefault
//
//  Created by 島田洋輝 on 2016/02/01.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // ユーザーデフォルトを用意する
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        // データを読みだして
        var myStr = myDefault.stringForKey("myString")
        
        // 文字列が入っていたら表示する
        if let tmpStr = myStr{
            myTextField.text = tmpStr
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapReturnKey(sender: UITextField) {
        // ユーザーデフォルトを用意する
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        // データを書き込んで
        myDefault.setObject(sender.text, forKey: "myString")
        
        // 即反映させる
        myDefault.synchronize()
    }

}

