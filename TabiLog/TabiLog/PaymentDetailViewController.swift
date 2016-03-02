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



    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var currencyField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var pictureBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
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
        makeDatePicker()
    }
    
    override func viewWillAppear(animated: Bool) {
        makePickerView()
        deleteBtn.hidden = true
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
    
    @IBAction func editDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.locale = NSLocale(localeIdentifier: "ja_JP")
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func editCategory(sender: UITextField) {
        selectedPickerView = "分類"
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryField.inputView = pickerView
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
    
    @IBAction func editCurrency(sender: AnyObject) {
        selectedPickerView = "通貨"
        let pickerView = UIPickerView()
        pickerView.delegate = self
        currencyField.inputView = pickerView
    }
    
    @IBAction func touchRegist(sender: UIButton) {
        var managedObject: AnyObject?
        if self.selectedManagedObject != nil {
            managedObject = self.selectedManagedObject as? AnyObject
        } else {
            // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
            let managedObjectContext = appDelegate.managedObjectContext
            // 新しくデータを追加するためのEntityを作成します
            managedObject = NSEntityDescription.insertNewObjectForEntityForName("Payment", inManagedObjectContext: managedObjectContext)
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
        date = sender.date
    }
    
    @IBAction func touchDelete(sender: UIButton) {
        let managedContext: NSManagedObjectContext = self.appDelegate.managedObjectContext
        managedContext.deleteObject(self.selectedManagedObject!)
        try! managedContext.save()
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
            categoryField.text = categoryListForPickerView[row] as String
            var i = 0
            for (data) in self.categoryList{
                if data["name"] as! String == categoryListForPickerView[row]{
                    self.categoryID = Int16(i)
                }
                i++
            }
        } else if selectedPickerView == "通貨" {
            currencyField.text = currencyList[row] as String
            self.currencyID = Int16(row)
        }
    }
    
    func setDefaultData(){
        if self.selectedManagedObject != nil {
            registBtn.setTitle("更新", forState: UIControlState.Normal)
            deleteBtn.hidden = false
            let paymentDetail = selectedManagedObject as! Payment
            self.dateField.text = appDelegate.getDateFormat(paymentDetail.date)
            self.date = paymentDetail.date
            self.price.text = String(Int(paymentDetail.price))
            self.currencyField.text = self.currencyList[Int(paymentDetail.currencyID)]
            self.currencyID = paymentDetail.currencyID
            self.categoryField.text = appDelegate.categoryList[Int(paymentDetail.categoryID)]["name"] as? String
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
    
    func donePressed(sender: UIBarButtonItem) {
        dateField.resignFirstResponder()
        categoryField.resignFirstResponder()
        currencyField.resignFirstResponder()
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        dateField.text = appDelegate.getDateFormat(NSDate())
        self.date = NSDate()
        dateField.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        self.date = sender.date
        dateField.text = appDelegate.getDateFormat(sender.date)
    }
    
    func makeDatePicker(){
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let todayBtn = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedToolBarBtn:")
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = ""
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        dateField.inputAccessoryView = toolBar
    }
    
    func makePickerView(){
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.text = ""
        label.textAlignment = NSTextAlignment.Center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        categoryField.inputAccessoryView = toolBar
        currencyField.inputAccessoryView = toolBar
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