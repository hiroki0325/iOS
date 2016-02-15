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
    
    @IBOutlet weak var myLabel: UILabel!
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
        
        myLabel.text = self.scLocationList["\(scSelectedIndex)"]!["name"] as! String
        
        myTextView.text = self.scLocationList["\(scSelectedIndex)"]!["description"] as! String
        var pictureName = scLocationList["\(scSelectedIndex)"]!["picture"] as! String

        myImageView.image = UIImage(named: "\(pictureName)")
        
        var location = getLocation(scLocationList["\(scSelectedIndex)"]!["name"] as! String)
        var locationArray = location["results"] as! NSArray
        
        var latitude = locationArray[0]["geometry"]!!["location"]!!["lat"] as! Double
        var longitude = locationArray[0]["geometry"]!!["location"]!!["lng"] as! Double
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        // 縮尺を設定
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        // 範囲オブジェクトを作成
        let region = MKCoordinateRegionMake(coordinate, span)
        
        self.myMapView.setRegion(region, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation(locationName:String)->NSDictionary{
        var url = "http://maps.google.com/maps/api/geocode/json?address=\(locationName)&sensor=false"
        var URL = NSURL(string: url)
        var request = NSURLRequest(URL: URL!)
        var jsondata = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        var jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(jsondata, options: []) as! NSDictionary
        
        return jsonDictionary
    }


}
