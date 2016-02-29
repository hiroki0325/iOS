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
            cell.categoryLabel.text = categoryList[indexPath.row]["name"] as? String
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
            //TODO:直す
            //self.CategoryList[sender.tag-100]["deleteFlg"] as! Int = 1
            appDelegate.myDefault.setObject(self.categoryList, forKey: "category")
            appDelegate.myDefault.synchronize()
        } else {
            //self.CategoryList[sender.tag-100]["deleteFlg"] as! Int = 0
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
    
}
