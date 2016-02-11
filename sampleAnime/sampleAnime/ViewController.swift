//
//  ViewController.swift
//  sampleAnime
//
//  Created by 島田洋輝 on 2016/02/09.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // アニメーション対象のView
    let aView = UIView(frame: CGRectMake(0,0,100,100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 青色に指定
        self.aView.backgroundColor = UIColor.blueColor()
        
        // 画面上に表示
        self.view.addSubview(aView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTap(sender: UIButton) {
        print("ボタン押したよ")
        
        // 緑に変わるアニメーション
        UIView.animateWithDuration(3, animations: { () -> Void in self.aView.backgroundColor = UIColor.orangeColor()}, completion: {finished in print("色が変わりました")})
    }


}

