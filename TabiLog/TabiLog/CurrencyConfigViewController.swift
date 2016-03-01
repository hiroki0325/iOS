//
//  CurrencyConfigViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/18.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class CurrencyConfigViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currencyTableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var currencyList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var cell = tableView.dequeueReusableCellWithIdentifier("currencyCell")! as UITableViewCell
        var currencyName = cell.viewWithTag(1) as! UILabel
        currencyName.text = currencyList[indexPath.row+1]["name"] as? String
        var rate = cell.viewWithTag(2) as! UITextField
        rate.text = String(currencyList[indexPath.row+1]["rate"] as! Double)
        rate.tag = 100+indexPath.row+1
        var useSwitch = cell.viewWithTag(3) as! UISwitch
        if currencyList[indexPath.row+1]["useFlg"] as! Int == 1 {
            useSwitch.on = true
        } else {
            useSwitch.on = false
        }
        useSwitch.tag = 200+indexPath.row+1
        
        return cell
    }
    
    @IBAction func changeRate(sender: UITextField) {
        updateCurrency(Double(sender.text!)!, key: "rate", tag: sender.tag, tagGap: 100)
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
        appDelegate.updateCurrencyLate()
        for(var i=1; i<appDelegate.defaultCurrency.count; i++){
            updateCurrency(Double(appDelegate.defaultCurrency[i]["rate"] as! Double), key: "rate", tag: i, tagGap: 0)
        }
        loadView()
        viewDidLoad()
    }
    
    
}
