//
//  SecondViewController.swift
//  homeworkOmikuji002
//
//  Created by 島田洋輝 on 2016/02/04.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var selectedDate:String = ""
    var omikuji = ["大吉","中吉","吉","末吉","凶","大凶"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        var rand = Int(arc4random()) % omikuji.count
        resultLabel.text = omikuji[rand]
        resultImage.image = UIImage(named: "\(omikuji[rand]).jpg")
        commentLabel.text = makeComment(omikuji[rand])
        dayLabel.text = selectedDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func makeComment(result: String)->String {
        if result == "大吉" {
            return "いいことあるよ！"
        } else if result == "中吉" || result == "吉" {
            return "まぁまぁだね"
        } else if result == "大凶" {
            return "今日は家でおとなしくしておこう…"
        } else {
            return "微妙だね…"
        }
    }

}
