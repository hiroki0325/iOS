//
//  NewTravelViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class NewTravelViewController: UIViewController {

    @IBOutlet weak var destination: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapRegist(sender: UIButton) {
        // AppDeleteをコードで読み込む
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = appDelegate.managedObjectContext
                
        // 新しくデータを追加するためのEntityを作成します
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Travel", inManagedObjectContext: managedObjectContext)
            
        // Todo EntityからObjectを生成し、Attributesに接続して値を代入
        let travel = managedObject as! Travel
        travel.destination = destination.text!
        travel.from = NSDate()
        travel.to = NSDate()
        travel.budget = 100
            
        // データの保存処理
        appDelegate.saveContext()
        
    }
    
    @IBAction func didFinishEditDestination(sender: UITextField) {
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
