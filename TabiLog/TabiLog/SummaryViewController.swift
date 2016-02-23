//
//  SummaryViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData
import Charts

class SummaryViewController: UIViewController {
    
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var paymentDetail:[NSDictionary] = []
    var categories:[String] = []
    var prices:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController!.selectedIndex = 1
        // 上記だけでOKっぽいが、後で不具合が生じた時のために下記も残しておく //
        //let vc = self.tabBarController!.viewControllers![1]
        //self.tabBarController!.selectedViewController = vc
        
        //TODO:↓動かない…//
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新規作成", style: UIBarButtonItemStyle.Plain, target: self, action: "newTravel")
        
        directionLabel.text = "direction"
        periodLabel.text = "period"
        priceLabel.text = calculatePrice()
        currencyButton.setTitle("円", forState: .Normal)

        // グラフの表示
        setChart(categories, values: prices)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculatePrice () -> String {
        var totalPrice:Double = 0
        var currencyList:[Double] = []
        self.prices = [0,0,0,0]
        
        // ユーザーデフォルトから通貨の情報を取得
        let myDefault = NSUserDefaults.standardUserDefaults()
        var currencyArray = myDefault.arrayForKey("currency")!
        var categoryArray = myDefault.arrayForKey("category") as Array!
        self.categories = categoryArray as! [String]
        for currency in currencyArray {
            var currencyDictionary = currency as! NSDictionary
            for(key,data) in currencyDictionary
            {
                currencyList.append(data as! Double)
            }
        }
        
        // コアデータからデータを取得
        read()
        for payment in self.paymentDetail{
            var currencyID = payment["currencyID"] as! Int
            var categoryID = payment["categoryID"] as! Int
            var price = payment["price"] as! Double
            totalPrice += price / currencyList[currencyID]
            self.prices[categoryID] += price / currencyList[currencyID]
        }
        return String(Int(totalPrice as! Double))
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
            let results = try! managedObjectContext.executeFetchRequest(fetchRequest)
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        self.pieChartView.animate(yAxisDuration: 2.0)
        // グラフの余白
        self.pieChartView.extraTopOffset = 0.0
        self.pieChartView.extraRightOffset = 0.0
        self.pieChartView.extraBottomOffset = 0.0
        self.pieChartView.extraLeftOffset = 0.0
        
        // タップでデータを選択できるか
        self.pieChartView.highlightPerTapEnabled = false
        // 回転させることが出来るか
        self.pieChartView.rotationEnabled = false
        
        self.pieChartView.noDataText = "表示するデータがありません"
        
        self.pieChartView.usePercentValuesEnabled = true
        self.pieChartView.descriptionText = ""
        
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: nil)
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        
        
        // %表示
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle;
        numberFormatter.maximumFractionDigits = 1;
        numberFormatter.multiplier = NSNumber(int: 1)
        numberFormatter.percentSymbol = " %";
        pieChartData.setValueFormatter(numberFormatter)
        
        self.pieChartView.data = pieChartData
        
    }
    
}
