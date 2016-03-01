//
//  PaymentDetailViewController.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/19.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData
import AssetsLibrary

class PaymentDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var registBtn: UIButton!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedManagedObject:NSManagedObject?
    var date:NSDate = NSDate()
    var categoryList = []
    var categoryListForPickerView:[String] = []
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
        appDelegate.readCategoryList()
        self.categoryList = appDelegate.categoryList
        for data in categoryList{
            if data["deleteFlg"] as! Int != 1 {
                categoryListForPickerView.append(data["name"] as! String)
            }
        }
        self.travelID = Int16(appDelegate.travelID)
        appDelegate.readCurrency()
        for var tmpCurrency in appDelegate.currencyList{
            if tmpCurrency["useFlg"] as! Int == 1 {
                self.currencyList.append(tmpCurrency["name"] as! String)
            }
        }
        setDefaultData()
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
        var managedObject: AnyObject?
        if self.selectedManagedObject != nil {
            managedObject = self.selectedManagedObject as? AnyObject
            print("更新")
        } else {
            // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
            let managedObjectContext = appDelegate.managedObjectContext
            // 新しくデータを追加するためのEntityを作成します
            managedObject = NSEntityDescription.insertNewObjectForEntityForName("Payment", inManagedObjectContext: managedObjectContext)
            print("新規")
        }
        
        // Todo EntityからObjectを生成し、Attributesに接続して値を代入
        let payment = managedObject as! Payment
        payment.categoryID = categoryID
        payment.currencyID = self.currencyID
        payment.date = date
        payment.comment = commentTextView.text as String?
        payment.picturePath = imageURL?.absoluteString
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
            return categoryListForPickerView.count
        } else if selectedPickerView == "通貨" {
            return currencyList.count
        } else {
            return 0
        }
    }
    
    // ピッカービューに表示する文字
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedPickerView == "分類" {
            return categoryListForPickerView[row] as String
        } else if selectedPickerView == "通貨" {
            return currencyList[row] as String
        } else {
            return nil
        }
    }
    
    // ピッカービューで選択されたときに行う処理
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedPickerView == "分類" {
            categoryBtn.setTitle(categoryListForPickerView[row] as String, forState: UIControlState.Normal)
            var i = 0
            for (data) in self.categoryList{
                if data["name"] as! String == categoryListForPickerView[row]{
                    self.categoryID = Int16(i)
                }
                i++
            }
        } else if selectedPickerView == "通貨" {
            currencyBtn.setTitle(currencyList[row] as String, forState: UIControlState.Normal)
            self.currencyID = Int16(row)
        }
    }
    
    func setDefaultData(){
        if self.selectedManagedObject != nil {
            registBtn.setTitle("更新", forState: UIControlState.Normal)
            let paymentDetail = selectedManagedObject as! Payment
            self.dateBtn.setTitle(appDelegate.getDateFormat(paymentDetail.date), forState: UIControlState.Normal)
            self.date = paymentDetail.date
            self.price.text = String(Int(paymentDetail.price))
            self.currencyBtn.setTitle(self.currencyList[Int(paymentDetail.currencyID)], forState: UIControlState.Normal)
            self.currencyID = paymentDetail.currencyID
            self.categoryBtn.setTitle(appDelegate.categoryList[Int(paymentDetail.categoryID)]["name"] as? String, forState: UIControlState.Normal)
            self.categoryID = paymentDetail.categoryID
            self.commentTextView.text = paymentDetail.comment
            if paymentDetail.picturePath != nil {
                self.imageURL = NSURL(string: paymentDetail.picturePath!)
                let url = NSURL(string: paymentDetail.picturePath!)
                getUIImagefromAsseturl(url!)
            }
        }
    }
    
    func getUIImagefromAsseturl (url: NSURL) {
        let asset = ALAssetsLibrary()
        asset.assetForURL(url, resultBlock: { asset in
            if let ast = asset {
                let assetRep = ast.defaultRepresentation()
                let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                let image = UIImage(CGImage: iref)
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
                })
            }
            }, failureBlock: { error in
                print("Error: \(error)")
        })
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