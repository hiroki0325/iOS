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
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var to: UITextField!
    @IBOutlet weak var budget: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var register: UIButton!
    
    var selectedPeriod = "from"
    var fromDate:NSDate = NSDate()
    var toDate:NSDate = NSDate()
    var budgetCurrency:String = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        travel.from = fromDate
        travel.to = toDate
        travel.budget = Float(budget.text!)!
        travel.budgetCurrency = "en"
        
        // データの保存処理
        appDelegate.saveContext()
        
    }
    
    @IBAction func didFinishEditDestination(sender: UITextField) {
    }
    
    @IBAction func touchCloseBtn(sender: UIButton) {
        self.view.endEditing(true)
        closeButton.hidden = true
        datePicker.hidden = true
        register.hidden = false
    }
    
    @IBAction func touchFrom(sender: UITextField) {
        self.view.endEditing(true)
        closeButton.hidden = false
        datePicker.hidden = false
        register.hidden = true
        self.selectedPeriod = "from"
    }
    
    @IBAction func touchTo(sender: UITextField) {
        self.view.endEditing(true)
        closeButton.hidden = false
        datePicker.hidden = false
        register.hidden = true
        self.selectedPeriod = "to"
    }
    
    @IBAction func didEndEditFrom(sender: UITextField) {
        from.resignFirstResponder()
    }
    
    @IBAction func didEndEditTo(sender: UITextField) {
        to.resignFirstResponder()
    }

    @IBAction func didValueChanged(sender: UIDatePicker) {
        if self.selectedPeriod == "from" {
            from.text = getDateFormat(sender.date)
            fromDate = sender.date
        } else if selectedPeriod == "to" {
            to.text = getDateFormat(sender.date)
            toDate = sender.date
        }
    }
    
    // NSDateをフォーマットして返す
    func getDateFormat(date: NSDate = NSDate()) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        return dateFormatter.stringFromDate(date)
    }
    
    @IBAction func didEndEditBudget(sender: UITextField) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
