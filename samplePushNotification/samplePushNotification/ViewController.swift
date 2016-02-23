//
//  ViewController.swift
//  samplePushNotification
//
//  Created by 島田洋輝 on 2016/02/23.
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
    
    @IBAction func tapBtn(sender: UIButton) {
        print("押されたよ")
        
        // ローカル通知の設定
        let notification :UILocalNotification = UILocalNotification()
        
        // タイトルを表示
        notification.alertTitle = "Fire"
        
        // 通知メッセージ
        notification.alertBody = "ファイヤー！！！"
        
        // タイムゾーンの設定
        notification.timeZone = NSTimeZone.defaultTimeZone()
            
        // 10秒後に通知を設定
        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
        
        // Notificationを表示する
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }


}

