//
//  PaymentDetailViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/19.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class PaymentDetailViewController: UIViewController {

    
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var picture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.hidden = true
        pickerView.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchDate(sender: UIButton) {
    }
    
    @IBAction func touchCategory(sender: UIButton) {
    }
    
    @IBAction func touchPicture(sender: UIButton) {
    }
    
    @IBAction func editPrice(sender: UITextField) {
    }
    
    @IBAction func touchCurrency(sender: UIButton) {
    }
    
    @IBAction func touchRegist(sender: UIButton) {
    }
}
