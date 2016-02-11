//
//  ViewController.swift
//  sampleHelloWorld
//
//  Created by 島田洋輝 on 2016/01/25.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var someonesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面が起動された時に呼ばれる
        myLabel.text = "こんにちは！"
        myLabel.text = "コンニチハ！"
    }
    
    var toggleState = 1
    
    @IBAction func btnTap(sender: UIButton) {
        if toggleState == 1 {
            myLabel.text = "Hello world！"
            toggleState = 2
        } else {
            myLabel.text = "こんにちは,世界！"
            toggleState = 1
        }
    }

    @IBAction func tapSomeonesBtn(sender: UIButton) {
        let myAlert = UIAlertController(title: "押しちゃった…", message: "ダメってゆったやん(´・ω・｀)", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        myAlert.addAction(OKAction)
        presentViewController(myAlert, animated: true, completion: nil)
        let rand = arc4random_uniform(3)
        if rand == 1 {
            myLabel.text = "こんにちは,セブ！"
        } else if rand == 2 {
            myLabel.text = "I love Cebu"
        } else {
            myLabel.text = "I am 店長"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // メモリ不足の通知を受け取った時
    }

}