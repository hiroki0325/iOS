//
//  ViewController.swift
//  homeworkiAd
//
//  Created by 島田洋輝 on 2016/02/10.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var selectedIndex = -1
    var programmingList:NSArray = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // json.txtファイルを読み込んで
        var path = NSBundle.mainBundle().pathForResource("programming", ofType: "txt")
        var jsondata = NSData(contentsOfFile: path!)
        
        // 配列データに変換して
        var programmingList = try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: []) as! NSArray
        self.programmingList = programmingList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programmingList.count
    }
    
    // 表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(
            style: .Default,
            reuseIdentifier: "myCell")
        cell.textLabel?.text = self.programmingList[indexPath.row]["name"] as! String
        
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
    }


}

