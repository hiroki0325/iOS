//
//  TravelListViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class TravelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var travelListTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var travelNum = 0
    var travelDetail:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新規作成", style: UIBarButtonItemStyle.Plain, target: self, action: "newTravel")
    }
    
    override func viewWillAppear(animated: Bool) {
        read()
        self.travelListTableView.reloadData()
    }
    
    
    // すでに存在するデータの読み込み処理
    func read() {
        // データの初期化
        self.travelDetail = []
        
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = appDelegate.managedObjectContext
            
        // Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Travel", inManagedObjectContext: managedObjectContext)
    
        let fetchRequest = NSFetchRequest(entityName: "Travel")
        fetchRequest.entity = entityDiscription
        
        // errorが発生した際にキャッチするための変数
        var error: NSError? = nil
        
        // フェッチリクエスト (データの検索と取得処理) の実行
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.travelNum = results.count
            for managedObject in results {
                let travel = managedObject as! Travel
                var newTravel:NSDictionary =
                [
                    "destination":travel.destination,
                    "from":travel.from,
                    "to":travel.to,
                    "budget":travel.budget 
                ]
                travelDetail.append(newTravel)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    func newTravel(){
        performSegueWithIdentifier("createNewTravel",sender: nil)
    }

    
    // tableView の設定 //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.travelNum
    }
    
    // 表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var from = appDelegate.getDateFormat(travelDetail[indexPath.row]["from"] as! NSDate)
        var to = appDelegate.getDateFormat(travelDetail[indexPath.row]["to"] as! NSDate)
        var cell = tableView.dequeueReusableCellWithIdentifier("travelList") as! TravelListTableViewCell
        cell.directionLabel?.text = travelDetail[indexPath.row]["destination"] as? String
        cell.periodLabel?.text = "\(from)~\(to)"
        
        // アイコンを付ける
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    // 選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // Segueで画面遷移する時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnList(segue: UIStoryboardSegue){
        // 移動画面からの戻り口
        
    }

    

}
