//
//  GameViewController.swift
//  sampleGame
//
//  Created by 島田洋輝 on 2016/02/12.
//  Copyright (c) 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        var manager = CMMotionManager()
        //取得の間隔
        manager.accelerometerUpdateInterval = 0.01;
        let handler:CMAccelerometerHandler = (data:CMAccelerometerData!, error:NSError!); -> { Void in
            println(data.acceleration.x)
            println(data.acceleration.y)
            println(data.acceleration.z)
            }
        
        //取得開始
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:handler)
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
