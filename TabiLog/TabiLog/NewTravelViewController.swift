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
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedPeriod = "from"
    var fromDate:NSDate?
    var toDate:NSDate?
    var madeTravelID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDatePicker()
    }
    
    override func viewWillAppear(animated: Bool) {
        changeButtonStatus()
    }
    
    @IBAction func tapRegist(sender: UIButton) {
        appDelegate.getLatestTravelID()
        appDelegate.myDefault.setInteger(appDelegate.latestTravelID+1, forKey: "latestTravelID")
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = appDelegate.managedObjectContext
                
        // 新しくデータを追加するためのEntityを作成します
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Travel", inManagedObjectContext: managedObjectContext)
            
        // travel EntityからObjectを生成し、Attributesに接続して値を代入
        let travel = managedObject as! Travel
        travel.id = Int16(appDelegate.latestTravelID+1)
        travel.destination = destination.text!
        travel.from = fromDate!
        travel.to = toDate!
        travel.budget = 0
        travel.budgetCurrencyID = 0
        travel.deleteFlg = 0
        
        // データの保存処理
        appDelegate.saveContext()
        
        // 初期通貨データの作成
        setDefaultCurrencyList(appDelegate.latestTravelID+1)
        
    }
    
    @IBAction func editFrom(sender: UITextField) {
        self.fromDate = nil
        self.selectedPeriod = "from"
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        datePickerView.maximumDate = self.toDate
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func editTo(sender: UITextField) {
        self.toDate = nil
        self.selectedPeriod = "to"
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        datePickerView.minimumDate = self.fromDate
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func didFinishEditDestination(sender: UITextField) {
        changeButtonStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 通貨情報のデフォルト値を設定する関数
    func setDefaultCurrencyList(madeTravelID:Int){
        let managedObjectContext = appDelegate.managedObjectContext
        var currencyID:Int16 = 1
        appDelegate.updateCurrencyLate()
        for data in appDelegate.defaultCurrency{
            let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: managedObjectContext)
            let currency = managedObject as! Currency
            currency.name = data["name"] as! String
            currency.rate = data["rate"] as! Double
            currency.useFlg = 1
            currency.travelID = Int16(madeTravelID) as Int16
            currency.currencyID = currencyID
            appDelegate.saveContext()
            currencyID++
        }
    }
    
    func donePressed(sender: UIBarButtonItem) {
        if self.selectedPeriod == "from" {
            fromTextField.resignFirstResponder()
        } else {
            toTextField.resignFirstResponder()
        }
        changeButtonStatus()
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        if self.selectedPeriod == "from" {
            fromTextField.text = appDelegate.getDateFormat(NSDate())
            self.fromDate = NSDate()
            fromTextField.resignFirstResponder()
        } else {
            toTextField.text = appDelegate.getDateFormat(NSDate())
            self.toDate = NSDate()
            toTextField.resignFirstResponder()
        }
        changeButtonStatus()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        if self.selectedPeriod == "from" {
            self.fromDate = sender.date
            fromTextField.text = appDelegate.getDateFormat(sender.date)
        } else {
            self.toDate = sender.date
            toTextField.text = appDelegate.getDateFormat(sender.date)
        }
        changeButtonStatus()
    }
    
    func makeDatePicker(){
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedToolBarBtn:")
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = ""
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        fromTextField.inputAccessoryView = toolBar
        toTextField.inputAccessoryView = toolBar
    }
    
    func checkValidation() -> Bool {
        if (destination.text != "" && toTextField.text != "" &&  fromTextField.text != "") {
            return true
        } else {
            return false
        }
    }
    
    func changeButtonStatus(){
        if checkValidation() {
            register.enabled = true
        } else {
            register.enabled = false
        }
    }


}
