//
//  ViewController.swift
//  sampleCollectionView
//
//  Created by 島田洋輝 on 2016/02/12.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var musicList:[NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iTunesのAPIからmaroon5の情報を20件取得
        // 1. API = URLなので、string型でurlの文字列を生成
        let urlString:String = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?term=marron5&limit=20"
        // 2. string型からurl型に変換
        let url = NSURL(string: urlString)
        // 3. urlを使ってリクエストを発行（データくれ）
        var request = NSURLRequest(URL: url!)
        print(request)
        // 4. 取得したデータをjsonに変換
        var jsondata = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        // 5. jsonからdictionary型に変換
        var jsonDict = try! NSJSONSerialization.JSONObjectWithData(jsondata, options: []) as! NSDictionary
        // 6. 繰り返し処理を使って欲しいデータを配列に代入
        for(key, data) in jsonDict {
            if key as! String == "results" {
                var resultArray = data as! NSArray
                
                for(eachMusic) in resultArray {
                    var newMusic:NSDictionary =
                    [
                        "name":eachMusic["trackName"] as! String,
                        "image":eachMusic["artworkUrl100"] as! String
                    ]
                    
                    self.musicList.append(newMusic)
                }
            }
        }
        // 7. 配列の要素をcellに表示


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        cell.titleLabel.text = self.musicList[indexPath.row]["name"] as! String
        
        // 1. stringからurl
        let url = NSURL(string: self.musicList[indexPath.row]["image"] as! String)
        // 2. urlからdata
        let imageData:NSData = try! NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        // 3. dataからimage
        var img = UIImage(data: imageData)
        cell.myImageView.image = img
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)個目が選択されたよ")
    }

}

