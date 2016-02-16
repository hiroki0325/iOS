//
//  TravelListViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class TravelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var travelListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // 表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(
            style: .Default,
            reuseIdentifier: "myCell")
        if indexPath.row < 3 {
            cell.textLabel?.text = "hogehoge"
        } else {
            cell.textLabel?.text = "新規作成"
        }
        
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
        
        // SecondViewController へ遷移するために Segue を呼び出す
        if indexPath.row < 3 {
            performSegueWithIdentifier("newTravel",sender: nil)
        } else {
            performSegueWithIdentifier("showTravelDetail",sender: nil)
        }
    }
    
    // Segueで画面遷移する時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
