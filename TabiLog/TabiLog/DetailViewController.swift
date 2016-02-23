//
//  DetailViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var paymentDetail:[NSDictionary] = []
    var detailNum = 0
    var categoryList = []
    var currencyList:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // ↓動かない
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新規作成", style: UIBarButtonItemStyle.Plain, target: self, action: "newTravel")
    }
    
    override func viewWillAppear(animated: Bool) {
        read()
        self.tableView.reloadData()
        // ユーザーデフォルトを用意する
        var myDefault = NSUserDefaults.standardUserDefaults()
        // データを読みだす
        self.categoryList = myDefault.arrayForKey("category")!
        var currencyArray = myDefault.arrayForKey("currency")!
        for currency in currencyArray {
            var currencyDictionary = currency as! NSDictionary
            for(key,data) in currencyDictionary
            {
                self.currencyList.append(key as! String)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailNum+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("paymentDetail")! as UITableViewCell
        if indexPath.row != 0 {
            var dateLabel = cell.viewWithTag(1) as! UILabel
            var categoryLabel = cell.viewWithTag(2)as! UILabel
            var priceLabel = cell.viewWithTag(3) as! UILabel

            dateLabel.text = appDelegate.getDateFormat2((paymentDetail[indexPath.row-1]["date"] as? NSDate)!)
            categoryLabel.text = self.categoryList[(paymentDetail[indexPath.row-1]["categoryID"] as? Int)!] as? String
            var price:String =  ((paymentDetail[indexPath.row-1]["price"] as? Int)?.description)!
            var currency:String = self.currencyList[(paymentDetail[indexPath.row-1]["currencyID"] as? Int)!]
            priceLabel.text = price+currency
            
            cell.accessoryType = .DisclosureIndicator
            return cell
        } else {
            cell.textLabel!.text = "新規作成"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func returnDetail(segue: UIStoryboardSegue){
        // 移動画面からの戻り口
    }
    
    // すでに存在するデータの読み込み処理
    func read() {
        // データの初期化
        self.paymentDetail = []
        
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = appDelegate.managedObjectContext
        
        // Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Payment", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        fetchRequest.entity = entityDiscription
        let predicate = NSPredicate(format: "%K = %d", "travelID", appDelegate.travelID)
        fetchRequest.predicate = predicate

        
        // errorが発生した際にキャッチするための変数
        var error: NSError? = nil
        
        // フェッチリクエスト (データの検索と取得処理) の実行
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.detailNum = results.count
            for managedObject in results {
                let payment = managedObject as! Payment
                var newPayment:NSDictionary =
                [
                    "categoryID": Int(payment.categoryID),
                    "currencyID": Int(payment.currencyID),
                    "date": payment.date,
                    "picturePath":payment.picturePath,
                    "price":payment.price,
                    "travelID":Int(payment.travelID)
                ]
                paymentDetail.append(newPayment)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }


}
