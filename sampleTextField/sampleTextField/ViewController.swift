//
//  ViewController.swift
//  sampleTextField
//
//  Created by 島田洋輝 on 2016/01/27.
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

    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    
    // TODO:ラベルを用意してtestという文字が含まれていたら「testです」とラベルに表示、それ以外は入力された字をそのまま表示しましょう
    
    @IBAction func tapReturn(sender: UITextField) {
        if myTextField.text?.rangeOfString("test") != nil {
            testLabel.text = "testです"
        } else {
            testLabel.text = myTextField.text
        }
    }
    
    @IBAction func btnTap(sender: UIButton) {
        myTextField.resignFirstResponder()
        myTextField.text = ""
        testLabel.text = ""
    }
    
    
}

