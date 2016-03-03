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

class SummaryViewController: UIViewController, NADViewDelegate {
    
    private var nadView: NADView!
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var dots: UIPageControl!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var direction = "direction"
    var period = "period"
    var paymentDetail:[NSDictionary] = []
    var categories:[String] = []
    var prices:[Double] = []
    var categoriesForPiecharts:[String] = []
    var pricesForPiecharts:[Double] = []
    
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
        self.tabBarController!.selectedIndex = 1
        nadView.resume()
        scroll?.showsHorizontalScrollIndicator = false
        scroll?.showsVerticalScrollIndicator = false
        scroll?.pagingEnabled = true
        //dots.numberOfPages = 2

        directionLabel.text = appDelegate.direction
        periodLabel.text = appDelegate.period
        priceLabel.text = calculatePrice()
        currencyButton.setTitle("円", forState: .Normal)
        
        // 0円の分類を円グラフから消す
        formatForPiechart()
        
        // 円グラフの表示
        setChart(categoriesForPiecharts, values: pricesForPiecharts)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nadView.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    "price":payment.price,
                    "travelID":Int(payment.travelID)
                ]
                paymentDetail.append(newPayment)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    func calculatePrice () -> String {
        var totalPrice:Double = 0
        var currencyList:[Double] = []
        self.categories = []
        self.prices = []
        
        // 分類情報の取得
        appDelegate.readCategoryList()
        var categoryArray = appDelegate.categoryList
        for data in categoryArray{
            self.categories.append(data["name"] as! String)
        }
        
        // 分類ごとの合計金額計算用配列の初期化
        for(var i=0;i<self.categories.count;i++){
            self.prices.append(0)
        }
        
        // 通貨情報の取得
        appDelegate.readCurrency()
        var currencyArray = appDelegate.currencyList
        for currency in currencyArray {
            currencyList.append(currency["rate"] as! Double)
        }
        
        // コアデータからデータを取得
        read()
        for payment in self.paymentDetail{
            var currencyID = payment["currencyID"] as! Int
            var categoryID = payment["categoryID"] as! Int
            var price = payment["price"] as! Double
            
            // 合計金額に加算
            totalPrice += price / currencyList[currencyID]
            
            // 分類ごとの合計金額を計算（円グラフ用）
            self.prices[categoryID] += price / currencyList[currencyID]
        }
        return String(Int(totalPrice))
    }
    
    func formatForPiechart(){
        self.categoriesForPiecharts = []
        self.pricesForPiecharts = []
        
        var i = 0
        for data in self.prices{
            if data != 0 {
                self.pricesForPiecharts.append(data)
                self.categoriesForPiecharts.append(self.categories[i])
            }
            i++
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
    
    func nadViewDidFinishLoad(adView: NADView!) {
        print("delegate nadViewDidFinishLoad:")
        nadView.frame = CGRect(x: (self.view.frame.size.width - nadView.frame.size.width)/2, y: self.view.frame.size.height - nadView.frame.size.height - self.tabBarController!.tabBar.frame.size.height, width: nadView.frame.size.width, height: nadView.frame.size.height)
        self.view.addSubview(nadView)
    }
        
}
