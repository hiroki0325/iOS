//
//  ViewController.swift
//  sampleTableView002
//
//  Created by 島田洋輝 on 2016/02/05.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    


    @IBOutlet weak var myTableView: UITableView!
    
    var myAp = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if myTableView.respondsToSelector("separatorInset") {
            myTableView.separatorInset = UIEdgeInsetsZero;
        }
        
        if myTableView.respondsToSelector("layoutMargins") {
            myTableView.layoutMargins = UIEdgeInsetsZero;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAp.tea_list.count
    }
    
    // 表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(
            style: .Default,
            reuseIdentifier: "myCell")
        cell.textLabel?.text = myAp.tea_list[indexPath.row]["name"]
        
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
//        print("\(indexPath.row)行目を選択")
        
        selectedIndex = indexPath.row
        
        // SecondViewController へ遷移するために Segue を呼び出す
        performSegueWithIdentifier("showSecondView",sender: nil)
    }
    
    // Segueで画面遷移する時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        var secondVC = segue.destinationViewController as! SecondViewController
        secondVC.scSelectedIndex = selectedIndex
    }



}