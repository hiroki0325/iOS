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
            cell.categoryTextField.hidden = true
            cell.categoryTextField.tag = 200+indexPath.row
            cell.categoryTextField.frame = CGRectMake(cell.categoryBtn.frame.origin.x, cell.categoryBtn.frame.origin.y, cell.categoryBtn.frame.width, cell.categoryBtn.frame.height)
            cell.categoryBtn.setTitle(categoryList[indexPath.row]["name"] as? String, forState: UIControlState.Normal)
            cell.categoryBtn.tag = 300+indexPath.row
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
    
    @IBAction func editCategory(sender: UIButton) {
        sender.hidden = true
        var textField = view.viewWithTag(sender.tag-100) as! UITextField
        textField.text = sender.currentTitle
        textField.hidden = false
    }

    @IBAction func endEditCategory(sender: UITextField) {
        var newCategoryList:[AnyObject] = []
        if sender.text == ""{
            //削除
            var tmpCategoryList = NSMutableDictionary(dictionary: self.categoryList[sender.tag-200] as! [NSObject : AnyObject])
            tmpCategoryList["name"] = ""
            self.categoryList[sender.tag-200] = tmpCategoryList
            for(var i=0;i<categoryList.count;i++){
                if categoryList[i]["name"] as! String != "" {
                    var text = categoryList[i]["name"] as! String
                    var deleteFlg = categoryList[i]["deleteFlg"] as! Int
                    newCategoryList.append(["name":text,"deleteFlg":deleteFlg])
                    print(newCategoryList)
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
