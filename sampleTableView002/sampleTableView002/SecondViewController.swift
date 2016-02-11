//
//  SecondViewController.swift
//  sampleTableView002
//
//  Created by 島田洋輝 on 2016/02/05.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var teaName: UILabel!
    @IBOutlet weak var teaDiscription: UITextView!
    @IBOutlet weak var teaImage: UIImageView!
    
    var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
    var scSelectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
//        print("\(scSelectedIndex)行目が選択されました")
        teaName.text = myAp.tea_list[scSelectedIndex]["name"]
        teaDiscription.text = myAp.tea_list[scSelectedIndex]["discription"]
        teaImage.image = UIImage(named: myAp.tea_list[scSelectedIndex]["image"]!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
