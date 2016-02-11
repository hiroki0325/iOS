//
//  SecondViewController.swift
//  homeworkMapKit
//
//  Created by 島田洋輝 on 2016/02/11.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myImageView: UIImageView!
    
    var scSelectedIndex = -1
    var scLocationList:NSDictionary = ["": ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        myTextView.text = self.scLocationList["\(scSelectedIndex)"]!["description"] as! String
        var pictureName = scLocationList["\(scSelectedIndex)"]!["picture"] as! String

        myImageView.image = UIImage(named: "\(pictureName)")
        
        var latitude = scLocationList["\(scSelectedIndex)"]!["map"]!!["latitude"] as! Double
        var longitude = scLocationList["\(scSelectedIndex)"]!["map"]!!["longitude"] as! Double
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
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
