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
    var period = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新規作成", style: UIBarButtonItemStyle.Plain, target: self, action: "newTravel")
    }
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.readTravel()
        self.travelNum = appDelegate.travelNum
        self.travelDetail = appDelegate.travelDetail
        self.travelListTableView.reloadData()
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
        appDelegate.direction = (travelDetail[indexPath.row]["destination"] as? String)!
        appDelegate.travelID = indexPath.row+1
        var from = appDelegate.getDateFormat(travelDetail[indexPath.row]["from"] as! NSDate)
        var to = appDelegate.getDateFormat(travelDetail[indexPath.row]["to"] as! NSDate)
        period = "\(from)~\(to)"
        appDelegate.period = period
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

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.editing = editing
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 先にデータを更新する
        let managedContext: NSManagedObjectContext = self.appDelegate.managedObjectContext
        managedContext.deleteObject(appDelegate.managedObjects[indexPath.row])
        try! managedContext.save()
        
        // テーブルビュー用の配列を取得し直す
        appDelegate.readTravel()
        self.travelNum = appDelegate.travelNum
        self.travelDetail = appDelegate.travelDetail
        
        // それからテーブルの更新
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)],withRowAnimation: UITableViewRowAnimation.Fade)
        
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
    }

}
