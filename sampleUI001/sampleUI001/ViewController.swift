//
//  ViewController.swift
//  sampleUI001
//
//  Created by 島田洋輝 on 2016/02/09.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnOpen: UIButton!
    
    var openFlag = false
    let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
    var aView = UIView(frame: CGRectMake(0, 0, 0,250))


    override func viewDidLoad() {
        super.viewDidLoad()
        aView = UIView(frame: CGRectMake(0, myBoundSize.height, myBoundSize.width,250))
        self.aView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(aView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBtn(sender: UIButton) {
        
        if(openFlag){
            // アニメーション
            UIView.animateWithDuration(3, animations: {
                () -> Void in
                self.btnOpen.frame = CGRectMake(self.btnOpen.frame.origin.x, self.btnOpen.frame.origin.y + 250, self.btnOpen.frame.width, self.btnOpen.frame.height)
                self.aView.backgroundColor = UIColor.blueColor()
                self.aView.frame = CGRectMake(self.aView.frame.origin.x, self.aView.frame.origin.y + 250, self.aView.frame.width, self.aView.frame.height)
                }, completion: {finished in self.openFlag = false})
            
        }else{
            UIView.animateWithDuration(3, animations: {
                () -> Void in
                self.btnOpen.frame = CGRectMake(self.btnOpen.frame.origin.x, self.btnOpen.frame.origin.y - 250, self.btnOpen.frame.width, self.btnOpen.frame.height)
                self.aView.backgroundColor = UIColor.orangeColor()
                self.aView.frame = CGRectMake(self.aView.frame.origin.x, self.aView.frame.origin.y - 250, self.aView.frame.width, self.aView.frame.height)
                }, completion: {finished in self.openFlag = true})
        }
    }

}