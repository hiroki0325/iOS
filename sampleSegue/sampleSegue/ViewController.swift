//
//  ViewController.swift
//  sampleSegue
//
//  Created by 島田洋輝 on 2016/02/03.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // カウント用の変数
    var myCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnMenu(segue: UIStoryboardSegue){
        // 移動画面からの戻り口
        
        // myCount変数に、前の画面のtmpCountの値を受け取って
        let newVC = segue.sourceViewController as! secondViewController
        myCount = newVC.tmpCount
        
        // カウントアップ
        myCount++
        
        // 値を出力
        print("前の画面から戻ってきた時<\(myCount)>")
    }
    
    // 画面が切り替わる時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // カウントアップ
        myCount++
        // 次の画面のtmpCountに、myCountの値を受け渡す
        var newVC = segue.destinationViewController as! secondViewController
        newVC.tmpCount = myCount
    }

}

