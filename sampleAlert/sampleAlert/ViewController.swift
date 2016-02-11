//
//  ViewController.swift
//  sampleAlert
//
//  Created by 島田洋輝 on 2016/01/28.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBtn(sender: UIButton) {
        
        // アラートを作る
        var alertController = UIAlertController(
            title: "タイトル",
            message: "メッセージ",
            preferredStyle: .Alert)
        
        // OKボタンを作る
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { action in self.myOK() } ))
        
        // キャンセルボタンを追加
        alertController.addAction(UIAlertAction(
            title: "cancel",
            style: .Cancel,
            handler: { action in self.myCancel() } ))
        
        // アラートを表示する
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    // OKが選択されたとき呼ばれるメソッド
    func myOK(){
        print("OK")
    }
    // キャンセルが選択されたとき呼ばれるメソッド
    func myCancel(){
        print("キャンセル")
    }

}

