//
//  SecondViewController.swift
//  homeworkiAd
//
//  Created by 島田洋輝 on 2016/02/10.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import iAd

class SecondViewController: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myAdBannerView: ADBannerView!
    
    var scSelectedIndex = -1
    var programmingList:NSArray = [""]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.canDisplayBannerAds = true
        self.myAdBannerView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        // json.txtファイルを読み込んで
        var path = NSBundle.mainBundle().pathForResource("programming", ofType: "txt")
        var jsondata = NSData(contentsOfFile: path!)
        
        // 配列データに変換して
        var programmingList = try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: []) as! NSArray
        self.programmingList = programmingList
        
        myLabel.text = self.programmingList[scSelectedIndex]["name"] as! String
        myTextView.text = self.programmingList[scSelectedIndex]["discription"] as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // バナーに広告が表示された時
    func bannerViewDidLoadAd(banner: ADBannerView!){
        self.myAdBannerView.hidden = false
    }
    
    // バナーがクリックされた時
    func bannerViewActionShouldBeggin(banner: ADBannerView!, willLeaveApplication willLeave:Bool)->Bool{
        return willLeave
    }
    
    // 広告表示にエラーが発生した場合
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.myAdBannerView.hidden = true
    }

}
