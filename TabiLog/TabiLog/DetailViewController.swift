//
//  DetailViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NADViewDelegate {
    
    private var nadView: NADView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var paymentDetail:[NSDictionary] = []
    var detailNum = 0
    var categoryList = []
    var currencyList:[String] = []
    var managedObjects:[NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // NADViewクラスを生成
        nadView = NADView(frame: CGRect(x: 0, y: 0, width: 320, height: 50), isAdjustAdSize: true)
        // 広告枠のapikey/spotidを設定(必須)
        nadView.setNendID("e422de3890cc54751e0d731ba4b93ae7745726da", spotID: "552837")
        // nendSDKログ出力の設定(任意)
        nadView.isOutputLog = false
        // delegateを受けるオブジェクトを指定(必須)
        nadView.delegate = self
        // 読み込み開始(必須)
        nadView.load()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.width, height: self.tableView.frame.height-50)
        read()
        appDelegate.readCurrency()
        appDelegate.readCategoryList()
        self.categoryList = appDelegate.categoryList
        for var tmpCurrency in appDelegate.currencyList{
            self.currencyList.append(tmpCurrency["name"] as! String)
        }
        self.tableView.reloadData()
        nadView.resume()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nadView.pause()
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
            for data in self.categoryList {
                if data["ID"] as? Int == paymentDetail[indexPath.row-1]["categoryID"] as? Int {
                    categoryLabel.text = data["name"] as? String
                }
            }
            var price:String = (paymentDetail[indexPath.row-1]["price"] as! Int).description
            var currency:String = self.currencyList[(paymentDetail[indexPath.row-1]["currencyID"] as? Int)!]
            priceLabel.text = price+currency
            
            cell.accessoryType = .DisclosureIndicator
            cell.tag = 100+indexPath.row
            return cell
        } else {
            cell.textLabel!.text = "新規作成"
            var dateLabel = cell.viewWithTag(1) as! UILabel
            var categoryLabel = cell.viewWithTag(2)as! UILabel
            var priceLabel = cell.viewWithTag(3) as! UILabel
            priceLabel.text = ""
            dateLabel.text = ""
            categoryLabel.text = ""
            cell.tag = 100
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
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        let entityDiscription = NSEntityDescription.entityForName("Payment", inManagedObjectContext: managedObjectContext)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let predicate = NSPredicate(format: "%K = %d", "travelID", appDelegate.travelID)
        fetchRequest.entity = entityDiscription
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate

        
        // errorが発生した際にキャッチするための変数
        var error: NSError? = nil
        
        // フェッチリクエスト (データの検索と取得処理) の実行
        do {
            self.managedObjects = []
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.detailNum = results.count
            for managedObject in results {
                self.managedObjects.append(managedObject as! NSManagedObject)
                let payment = managedObject as! Payment
                var newPayment:NSDictionary =
                [
                    "categoryID": Int(payment.categoryID),
                    "currencyID": Int(payment.currencyID),
                    "date": payment.date,
                    "price":payment.price,
                    "travelID":Int(payment.travelID)
                ]
                paymentDetail.append(newPayment)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender?.tag > 100{
            let nextVC = segue.destinationViewController as! PaymentDetailViewController
            nextVC.selectedManagedObject = self.managedObjects[(sender?.tag)! - 101]
        }
    }
    
    
    func nadViewDidFinishLoad(adView: NADView!) {
        print("delegate nadViewDidFinishLoad:")
        nadView.frame = CGRect(x: (self.view.frame.size.width - nadView.frame.size.width)/2, y: self.view.frame.size.height - nadView.frame.size.height - self.tabBarController!.tabBar.frame.size.height, width: nadView.frame.size.width, height: nadView.frame.size.height)
        self.view.addSubview(nadView)
    }
        
}
