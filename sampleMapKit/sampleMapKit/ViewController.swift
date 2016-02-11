//
//  ViewController.swift
//  sampleMapKit
//
//  Created by 島田洋輝 on 2016/02/11.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 中心となる場所の座標オブジェクトを作成
        // アヤラ
        //  let coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759)
        // SM
        let coordinate = CLLocationCoordinate2DMake(10.31175, 123.918332)

        // オスロブ
        // let coordinate = CLLocationCoordinate2DMake(9.56304, 123.415926)
        
        // 縮尺を設定
        let span = MKCoordinateSpanMake(0.025, 0.025)
        
        // 範囲オブジェクトを作成
        let region = MKCoordinateRegionMake(coordinate, span)
        
        self.myMapView.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

