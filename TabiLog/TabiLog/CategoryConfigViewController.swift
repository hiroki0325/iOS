//
//  CategoryConfigViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/19.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class CategoryConfigViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var categoryList:[AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count+1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row != categoryList.count {
            let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! CustomCell
            cell.categoryTextField.tag = 200+indexPath.row
            cell.categoryTextField.text = categoryList[indexPath.row]["name"] as? String

            cell.categorySwitch.tag = 100+indexPath.row
            if categoryList[indexPath.row]["deleteFlg"] as! Int == 0 {
                cell.categorySwitch.on = true
            } else {
                cell.categorySwitch.on = false
            }
            if categoryList[indexPath.row]["ID"] as! Int == 100 {
                cell.categorySwitch.hidden = true
                cell.categoryTextField.enabled = false
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newCell", forIndexPath: indexPath)
            var newCategoryTextField = cell.viewWithTag(3) as! UITextField
            newCategoryTextField.text = ""
            newCategoryTextField.placeholder = "新規作成"
            return cell
        }
    }

    @IBAction func changeSwitch(sender: UISwitch) {
        if sender.on == true {
            var tmpCategoryList = NSMutableDictionary(dictionary: self.categoryList[sender.tag-100] as! [NSObject : AnyObject])
            tmpCategoryList["deleteFlg"] = 0
            self.categoryList[sender.tag-100] = tmpCategoryList
            appDelegate.myDefault.setObject(self.categoryList, forKey: "category")
            appDelegate.myDefault.synchronize()
        } else {
            var tmpCategoryList = NSMutableDictionary(dictionary: self.categoryList[sender.tag-100] as! [NSObject : AnyObject])
            tmpCategoryList["deleteFlg"] = 1
            self.categoryList[sender.tag-100] = tmpCategoryList
            appDelegate.myDefault.setObject(self.categoryList, forKey: "category")
            appDelegate.myDefault.synchronize()
        }
    }
    
    @IBAction func makeNewCategory(sender: UITextField) {
        if sender.text != "" {
            appDelegate.getnextCategoryID()
            var text = String(sender.text!)
            self.categoryList.append(["ID":appDelegate.nextCategoryID,"name":text,"deleteFlg":0])
            appDelegate.myDefault.setObject(self.categoryList, forKey: "category")
            appDelegate.myDefault.setInteger(appDelegate.nextCategoryID+1, forKey: "nextCategoryID")
            appDelegate.myDefault.synchronize()
            reloadData()
        }
    }
    
    @IBAction func endEditCategory(sender: UITextField) {
        var newCategoryList:[AnyObject] = []
        //削除
        if sender.text == ""{
            var tmpCategoryList = NSMutableDictionary(dictionary: self.categoryList[sender.tag-200] as! [NSObject : AnyObject])
            tmpCategoryList["name"] = ""
            self.categoryList[sender.tag-200] = tmpCategoryList
            for(var i=0;i<categoryList.count;i++){
                if categoryList[i]["name"] as! String != "" {
                    var id = categoryList[i]["ID"] as! Int
                    var text = categoryList[i]["name"] as! String
                    var deleteFlg = categoryList[i]["deleteFlg"] as! Int
                    newCategoryList.append(["ID":id,"name":text,"deleteFlg":deleteFlg])
                }
            }
            editTravel(self.categoryList[sender.tag-200]["ID"] as! Int)
        } else {
            //編集
            var tmpCategoryList = NSMutableDictionary(dictionary: self.categoryList[sender.tag-200] as! [NSObject : AnyObject])
            tmpCategoryList["name"] = sender.text
            self.categoryList[sender.tag-200] = tmpCategoryList
            newCategoryList = self.categoryList
        }
        appDelegate.myDefault.setObject(newCategoryList, forKey: "category")
        appDelegate.myDefault.synchronize()
        appDelegate.categoryList = []
        reloadData()
    }
    
    // 削除されたカテゴリに紐付いていた支払い情報のカテゴリを書き換える処理
    func editTravel(categoryID:Int) {
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDiscription = NSEntityDescription.entityForName("Payment", inManagedObjectContext: managedObjectContext)
        let fetchRequest = NSFetchRequest(entityName: "Payment")
        fetchRequest.entity = entityDiscription
        let predicate = NSPredicate(format: "%K = %d", "categoryID", Int16(categoryID))
        fetchRequest.predicate = predicate
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let payment = managedObject as! Payment
                payment.categoryID = Int16(100)
                appDelegate.saveContext()
            }
        } catch let error1 as NSError {
            print(error1)
        }
    }
    
    func reloadData(){
        self.categoryList = []
        appDelegate.readCategoryList()
        self.categoryList = appDelegate.categoryList as [AnyObject]
        self.collectionView.reloadData()
        loadView()
    }
    
    
}
