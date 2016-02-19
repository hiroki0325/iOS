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
    @IBOutlet weak var from: UIButton!
    @IBOutlet weak var to: UIButton!
    @IBOutlet weak var budget: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var currency: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedPeriod = "from"
    var fromDate:NSDate = NSDate()
    var toDate:NSDate = NSDate()
    var budgetCurrencyID:Int16 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        currency.setTitle("円", forState: UIControlState.Normal)
    }
    
    @IBAction func tapRegist(sender: UIButton) {
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = appDelegate.managedObjectContext
                
        // 新しくデータを追加するためのEntityを作成します
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Travel", inManagedObjectContext: managedObjectContext)
            
        // Todo EntityからObjectを生成し、Attributesに接続して値を代入
        let travel = managedObject as! Travel
        travel.destination = destination.text!
        travel.from = fromDate
        travel.to = toDate
        travel.budget = Float(budget.text!)!
        travel.budgetCurrencyID = budgetCurrencyID
        
        // データの保存処理
        appDelegate.saveContext()
        
    }
    
    @IBAction func didFinishEditDestination(sender: UITextField) {
    }
    
    @IBAction func didEndEditBudget(sender: UITextField) {
        budget.resignFirstResponder()
    }
    
    @IBAction func touchCloseBtn(sender: UIButton) {
        self.view.endEditing(true)
        closeButton.hidden = true
        datePicker.hidden = true
        pickerView.hidden = true
    }
    
    
    @IBAction func touchFrom(sender: UIButton) {
        self.view.endEditing(true)
        closeButton.hidden = false
        datePicker.hidden = false
        self.selectedPeriod = "from"
    }
    
    @IBAction func touchTo(sender: UIButton) {
        self.view.endEditing(true)
        closeButton.hidden = false
        datePicker.hidden = false
        self.selectedPeriod = "to"
    }

    @IBAction func touchCurrency(sender: UIButton) {
        self.view.endEditing(true)
        closeButton.hidden = false
        pickerView.hidden = false
    }
    
    @IBAction func didValueChanged(sender: UIDatePicker) {
        if self.selectedPeriod == "from" {
            from.setTitle(appDelegate.getDateFormat(sender.date), forState: UIControlState.Normal)
            fromDate = sender.date
        } else if selectedPeriod == "to" {
            to.setTitle(appDelegate.getDateFormat(sender.date), forState: UIControlState.Normal)
            toDate = sender.date
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // データを配列で用意する
    var currencyList = ["円", "ドル", "ペソ", "元"]
        
    // ピッカービューの列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ピッカービューの行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList.count
    }
    
    // ピッカービューに表示する文字
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList[row]
    }
    
    // ピッカービューで選択されたときに行う処理
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currency.setTitle(currencyList[row], forState: UIControlState.Normal)
        self.budgetCurrencyID = Int16(row)
    }

}
