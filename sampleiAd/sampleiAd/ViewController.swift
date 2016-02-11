//
//  ViewController.swift
//  sampleiAd
//
//  Created by 島田洋輝 on 2016/02/10.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController {

    @IBOutlet weak var myAdBanner: ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canDisplayBannerAds = true
        self.myAdBanner.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // バナーに広告が表示された時
    func bannerViewDidLoadAd(banner: ADBannerView!){
        self.myAdBanner.hidden = false
    }
    
    // バナーがクリックされた時
    func bannerViewActionShouldBeggin(banner: ADBannerView!, willLeaveApplication willLeave:Bool)->Bool{
        return willLeave
    }
    
    // 広告表示にエラーが発生した場合
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error:NSError!){
        self.myAdBanner.hidden = true
    }

}

