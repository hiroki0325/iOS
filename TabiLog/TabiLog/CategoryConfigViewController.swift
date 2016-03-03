//
//  CategoryConfigViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/19.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class CategoryConfigViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var categoryList:[AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.categoryList = []
        appDelegate.readCategoryList()
        self.categoryList = appDelegate.categoryList as [AnyObject]
        self.collectionView.reloadData()
        self.collectionView.frame = CGRectMake(collectionView.frame.origin.x, collectionView.frame.origin.y, collectionView.frame.width, collectionView.frame.height)
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
            var text = String(sender.text!)
            self.categoryList.append(["name":text,"deleteFlg":0])
            appDelegate.myDefault.setObject(self.categoryList, forKey: "category")
            appDelegate.myDefault.synchronize()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func endEditCategory(sender: UITextField) {
        var newCategoryList:[AnyObject] = []
        //削除
        if sender.text == "" && self.categoryList.count == 1 {
            alert()
        } else {
            if sender.text == ""{
                var tmpCategoryList = NSMutableDictionary(dictionary: self.categoryList[sender.tag-200] as! [NSObject : AnyObject])
                tmpCategoryList["name"] = ""
                self.categoryList[sender.tag-200] = tmpCategoryList
                for(var i=0;i<categoryList.count;i++){
                    if categoryList[i]["name"] as! String != "" {
                        var text = categoryList[i]["name"] as! String
                        var deleteFlg = categoryList[i]["deleteFlg"] as! Int
                        newCategoryList.append(["name":text,"deleteFlg":deleteFlg])
                    }
                }
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
            loadView()
            viewWillAppear(false)
        }
    }
    
    func alert(){
        var alertController = UIAlertController(
            title: "",
            message: "少なくとも1つは分類を残しておく必要があります",
            preferredStyle: UIAlertControllerStyle.ActionSheet
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
