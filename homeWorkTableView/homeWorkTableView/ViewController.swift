//
//  ViewController.swift
//  homeWorkTableView
//
//  Created by 島田洋輝 on 2016/02/04.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
        cell.textLabel?.text = "\(indexPath.row)行目"
        // 文字を茶色にする
        cell.textLabel?.textColor = UIColor.brownColor()
        // 文字サイズを20にする
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        // チェックマークをつける
        cell.accessoryType = .Checkmark
        return cell
    }
    
    // ステータスバーを非表示にする
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

