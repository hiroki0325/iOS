//
//  PaymentDetailViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/19.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

class PaymentDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var closeBtn: UIButton!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var date:NSDate = NSDate()
    var categoryList = ["日用品","食費","交通費","娯楽費"]
    var categoryID:Int16 = 0
    var currencyList:[String] = []
    var currencyID:Int16 = 0
    var selectedPickerView = ""
    var imageURL:NSURL!
    var travelID:Int16 = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.hidden = true
        pickerView.hidden = true
        closeBtn.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.travelID = Int16(appDelegate.travelID)
        appDelegate.readCurrency()
        for var tmpCurrency in appDelegate.currencyList{
            self.currencyList.append(tmpCurrency["name"] as! String)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func touchDate(sender: UIButton) {
        datePicker.hidden = false
        closeBtn.hidden = false
    }
    
    @IBAction func touchCategory(sender: UIButton) {
        selectedPickerView = "分類"
        pickerView.reloadAllComponents()
        closeBtn.hidden = false
        pickerView.hidden = false
    }
    
    @IBAction func touchPicture(sender: UIButton) {
        // フォトライブラリを使用できるか確認
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editPrice(sender: UITextField) {
    }
    
    @IBAction func touchCurrency(sender: UIButton) {
        selectedPickerView = "通貨"
        pickerView.reloadAllComponents()
        closeBtn.hidden = false
        pickerView.hidden = false
    }
    
    @IBAction func touchRegist(sender: UIButton) {
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = appDelegate.managedObjectContext
        
        // 新しくデータを追加するためのEntityを作成します
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Payment", inManagedObjectContext: managedObjectContext)
        
        // Todo EntityからObjectを生成し、Attributesに接続して値を代入
        let payment = managedObject as! Payment
        payment.categoryID = categoryID
        payment.currencyID = self.currencyID
        payment.date = date
        payment.picturePath = imageURL.absoluteString
        payment.price = NSString(string:price.text!).floatValue
        payment.travelID = self.travelID
        
        // データの保存処理
        appDelegate.saveContext()
        
    }
    
    @IBAction func changeDatePicker(sender: UIDatePicker) {
        dateBtn.setTitle(appDelegate.getDateFormat(sender.date), forState: UIControlState.Normal)
        date = sender.date
    }
    
    @IBAction func touchCloseBtn(sender: UIButton) {
        self.view.endEditing(true)
        closeBtn.hidden = true
        datePicker.hidden = true
        pickerView.hidden = true
    }
    
    
    // ピッカービューの列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ピッカービューの行数
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedPickerView == "分類" {
            return categoryList.count
        } else if selectedPickerView == "通貨" {
            return currencyList.count
        } else {
            return 0
        }
    }
    
    // ピッカービューに表示する文字
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedPickerView == "分類" {
            return categoryList[row]
        } else if selectedPickerView == "通貨" {
            return currencyList[row] as? String
        } else {
            return nil
        }
    }
    
    // ピッカービューで選択されたときに行う処理
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedPickerView == "分類" {
            categoryBtn.setTitle(categoryList[row], forState: UIControlState.Normal)
            self.categoryID = Int16(row)
        } else if selectedPickerView == "通貨" {
            currencyBtn.setTitle(currencyList[row] as? String, forState: UIControlState.Normal)
            self.currencyID = Int16(row)
        }
    }
}

extension PaymentDetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 選択した画像・写真を取得し、imageViewに表示
        if let info = editingInfo, let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageView.image = editedImage
        }else{
            imageView.image = image
        }
        
        imageURL = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        
        // フォトライブラリの画像・写真選択画面を閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}