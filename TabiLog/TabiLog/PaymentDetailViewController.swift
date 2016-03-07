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
        imageView.image = UIImage(named: "noImage.jpg")
        makeDatePicker()
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0).CGColor
        commentTextView.layer.cornerRadius = 5
        pictureBtn.layer.cornerRadius = 10
        registBtn.layer.cornerRadius = 10
        makeData()
        setDefaultData()
    }
    
    override func viewWillAppear(animated: Bool) {
        makePickerView()
        self.travelID = Int16(appDelegate.travelID)
        changeButtonStatus()
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
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editPrice(sender: UITextField) {
        changeButtonStatus()
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
        
        appDelegate.myDefault.setInteger(Int(currencyID), forKey: "lastCurrencyID")
        appDelegate.myDefault.synchronize()
        
    }
    
    func delete(){
        var alertController = UIAlertController(
            title: "",
            message: "本当に削除しますか？",
            preferredStyle: .Alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .Cancel,
                handler: nil
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Destructive,
                handler: {action in self.confirmedDelete()}
            )
        )

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func confirmedDelete(){
        let managedContext: NSManagedObjectContext = self.appDelegate.managedObjectContext
        managedContext.deleteObject(self.selectedManagedObject!)
        try! managedContext.save()
        performSegueWithIdentifier("returnDetail",sender: nil)
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
            for (data) in self.categoryList{
                if data["name"] as! String == categoryListForPickerView[row]{
                    self.categoryID = Int16(data["ID"] as! Int)
                }
            }
        } else if selectedPickerView == "通貨" {
            currencyField.text = currencyList[row] as String
            self.currencyID = Int16(row)
        }
        changeButtonStatus()
    }
    
    func setDefaultData(){
        if self.selectedManagedObject != nil {
            var deleteBtn:UIBarButtonItem = UIBarButtonItem(title: "削除", style: UIBarButtonItemStyle.Plain, target: self, action: "delete")
            deleteBtn.tintColor = UIColor.redColor()
            self.navigationItem.setRightBarButtonItems([deleteBtn], animated: true)
            registBtn.setTitle("更新", forState: UIControlState.Normal)
            let paymentDetail = selectedManagedObject as! Payment
            self.dateField.text = appDelegate.getDateFormat(paymentDetail.date)
            self.date = paymentDetail.date
            self.price.text = String(Int(paymentDetail.price))
            self.currencyField.text = self.currencyList[Int(paymentDetail.currencyID)]
            self.currencyID = paymentDetail.currencyID
            for data in self.categoryList{
                if data["ID"] as! Int == Int(paymentDetail.categoryID){
                    self.categoryField.text = data["name"] as? String
                }
            }
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
                let scale = CGFloat(assetRep.scale())
                let photoOrientation = assetRep.orientation().hashValue
                var orientation:UIImageOrientation?
                switch(photoOrientation) {
                case 0:
                    orientation = UIImageOrientation.Up
                case 1:
                    orientation = UIImageOrientation.Down
                case 2:
                    orientation = UIImageOrientation.Left
                default :
                    orientation = UIImageOrientation.Right
                }
                let image = UIImage(CGImage: iref, scale: scale, orientation:orientation!)
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
        changeButtonStatus()
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        dateField.text = appDelegate.getDateFormat(NSDate())
        self.date = NSDate()
        dateField.resignFirstResponder()
        changeButtonStatus()
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
        changeButtonStatus()
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
    
    func checkValidation() -> Bool {
        if (dateField.text != "" && categoryField.text != "" && price.text != "" &&  currencyField.text != "" && NSString(string:price.text!).floatValue != 0 && Float(price.text!) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func changeButtonStatus(){
        if checkValidation() {
            registBtn.enabled = true
        } else {
            registBtn.enabled = false
        }
    }
    
    func makeData(){
        appDelegate.readCategoryList()
        self.categoryList = appDelegate.categoryList
        for data in categoryList{
            if data["deleteFlg"] as! Int != 1 {
                categoryListForPickerView.append(data["name"] as! String)
            }
        }
        self.currencyList = []
        appDelegate.readCurrency()
        for var tmpCurrency in appDelegate.currencyList{
            if tmpCurrency["useFlg"] as! Int == 1 {
                self.currencyList.append(tmpCurrency["name"] as! String)
            }
        }
        appDelegate.lastCurrencyID = appDelegate.myDefault.integerForKey("lastCurrencyID")
        if appDelegate.lastCurrencyID != -1 {
            self.currencyID = Int16(appDelegate.lastCurrencyID)
            self.currencyField.text = self.currencyList[appDelegate.lastCurrencyID]
        }

    }
    
}

extension PaymentDetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // 写真選択時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 選択した画像を取得
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let photo:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                // ImageViewにその画像を設定
                imageView.image = photo
                imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    /**
     画像選択がキャンセルされた時に呼ばれる.
     */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}