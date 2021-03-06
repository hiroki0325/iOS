//
//  CurrencyConfigViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/18.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class CurrencyConfigViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var currencyTableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var currencyList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.reloadData()
        updateBtn.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(animated: Bool) {
        currencyList = []
        appDelegate.readCurrency()
        currencyList = appDelegate.currencyList
        self.currencyTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count-1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomTableCell = tableView.dequeueReusableCellWithIdentifier("currencyCell")! as! CustomTableCell
        var currencyName = cell.label
        currencyName.text = currencyList[indexPath.row+1]["name"] as? String
        var rate = cell.textField
        rate.text = String(currencyList[indexPath.row+1]["rate"] as! Double)
        rate.tag = 100+indexPath.row+1
        var useSwitch = cell.`switch`
        if currencyList[indexPath.row+1]["useFlg"] as! Int == 1 {
            useSwitch.on = true
        } else {
            useSwitch.on = false
        }
        useSwitch.tag = 200+indexPath.row+1
        
        return cell
    }
    
    @IBAction func changeRate(sender: UITextField) {
        if sender.text != "" && Double(sender.text!) != nil && Double(sender.text!) != 0 {
            updateCurrency(Double(sender.text!)!, key: "rate", tag: sender.tag, tagGap: 100)
        } else {
            alert()
        }

    }
    
    @IBAction func changeSwitch(sender: UISwitch) {
        if sender.on == true {
            updateCurrency(1, key: "useFlg", tag: sender.tag, tagGap: 200)
        } else {
            updateCurrency(0, key: "useFlg", tag: sender.tag, tagGap: 200)
        }
    }
    
    func updateCurrency(value:AnyObject,key:String,tag:Int,tagGap:Int){
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDiscription = NSEntityDescription.entityForName("Currency", inManagedObjectContext: managedObjectContext)
        let fetchRequest = NSFetchRequest(entityName: "Currency")
        fetchRequest.entity = entityDiscription
        let predicate = NSPredicate(format: "%K = %d", "travelID", appDelegate.travelID)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try managedObjectContext.executeFetchRequest(fetchRequest)
            let obj = results[tag-tagGap] as! NSManagedObject
            obj.setValue(value, forKey: key)
            appDelegate.saveContext()
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
    }
    
    @IBAction func tapBtn(sender: UIButton) {
        SVProgressHUD.showWithStatus("更新中")
        appDelegate.updateCurrencyLate()
        for(var i=1; i<appDelegate.defaultCurrency.count; i++){
            updateCurrency(Double(appDelegate.defaultCurrency[i]["rate"] as! Double), key: "rate", tag: i, tagGap: 0)
        }
        SVProgressHUD.showSuccessWithStatus("完了")
        loadView()
        viewDidLoad()
    }
    
    func alert(){
        var alertController = UIAlertController(
            title: "",
            message: "為替レートを正しく入力してください\n(レートに0を設定することは出来ません)",
            preferredStyle: .Alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil
            )
        )
        presentViewController(alertController, animated: true, completion: nil)
    }
        
}
