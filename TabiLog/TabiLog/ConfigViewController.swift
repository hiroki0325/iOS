//
//  ConfigViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NADViewDelegate {
    
    private var nadView: NADView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let index:[String] = ["分類設定","通貨設定","利用規約"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // NADViewクラスを生成
        nadView = NADView(frame: CGRect(x: 0, y: 0, width: 320, height: 50), isAdjustAdSize: true)
        // 広告枠のapikey/spotidを設定(必須)
        nadView.setNendID("e422de3890cc54751e0d731ba4b93ae7745726da", spotID: "552837")
        // nendSDKログ出力の設定(任意)
        nadView.isOutputLog = false
        // delegateを受けるオブジェクトを指定(必須)
        nadView.delegate = self
        // 読み込み開始(必須)
        nadView.load()
    }
    
    override func viewWillAppear(animated: Bool) {
        nadView.resume()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nadView.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return index.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell"+String(indexPath.row), forIndexPath: indexPath)
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = index[indexPath.row]
        
        return cell
    }
    
    func nadViewDidFinishLoad(adView: NADView!) {
        print("delegate nadViewDidFinishLoad:")
        nadView.frame = CGRect(x: (self.view.frame.size.width - nadView.frame.size.width)/2, y: self.view.frame.size.height - nadView.frame.size.height - self.tabBarController!.tabBar.frame.size.height, width: nadView.frame.size.width, height: nadView.frame.size.height)
        self.view.addSubview(nadView)
    }

}
