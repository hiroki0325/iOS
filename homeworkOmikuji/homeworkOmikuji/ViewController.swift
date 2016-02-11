//
//  ViewController.swift
//  homeworkOmikuji
//
//  Created by 島田洋輝 on 2016/01/28.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView!
    
    var omikuji = ["大吉","中吉","吉","末吉","凶","大凶"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapBtn(sender: UIButton) {
        // ランダムな抽選
        var random = Int(arc4random()) % omikuji.count
        
        // アラートを作る
        var alertController = UIAlertController(
            title: "今日の運勢",
            message: omikuji[random],
            preferredStyle: .Alert
        )
        
        // OKボタンを追加
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: {action in self.showImage(self.omikuji[random])}
            )
        )
        
        // アラートを表示する
        presentViewController(
            alertController,
            animated: true,
            completion: nil
        )
    }
    
    func showImage(result:String){
        myImage.image = UIImage(named: "\(result).jpg")
    }

}