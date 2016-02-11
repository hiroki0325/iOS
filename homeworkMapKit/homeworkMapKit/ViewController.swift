//
//  ViewController.swift
//  homeworkMapKit
//
//  Created by 島田洋輝 on 2016/02/11.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var locationList:NSDictionary = ["": ""]
    var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        // plistファイルを読み込んで
        var filePath = NSBundle.mainBundle().pathForResource("location", ofType: "plist")
        var locationList = NSDictionary(contentsOfFile: filePath!)
        self.locationList = locationList!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationList.count
    }
    
    // 表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(
            style: .Default,
            reuseIdentifier: "myCell")
        var locationName:String = self.locationList["\(indexPath.row)"]!["name"] as! String
        cell.textLabel?.text = locationName
        
        // 文字色を茶色にする
        cell.textLabel?.textColor = UIColor.brownColor()
        
        // 文字サイズを20にする
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        
        // アイコンを付ける
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    // 選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.row
        
        // SecondViewController へ遷移するために Segue を呼び出す
        performSegueWithIdentifier("showSecondView",sender: nil)
    }
    
    // Segueで画面遷移する時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        var secondVC = segue.destinationViewController as! SecondViewController
        secondVC.scSelectedIndex = selectedIndex
        secondVC.scLocationList = self.locationList
    }


}

