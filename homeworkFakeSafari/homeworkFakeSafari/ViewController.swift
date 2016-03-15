//
//  ViewController.swift
//  homeworkFakeSafari
//
//  Created by 島田洋輝 on 2016/02/01.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.delegate = self
        myBtn.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(animated: Bool) {
        if let url:String? = getUserDefault(){
            myTextField.text = url
            showWebView(url!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBtn(sender: UIButton) {
        let url = self.myTextField.text
        if url != "" {
            showWebView(url!)
            setUserDefault(url!)
        } else {
            emptyAlert()
        }
    }

    @IBAction func editEnd(sender: UITextField) {
        // TODO:IBActionと同じこと二度書いてる…
        //// 丸っと関数化する、が良いのだろうか。
        
        let url = myTextField.text
        if url != "" {
            showWebView(url!)
            setUserDefault(url!)
        } else {
            emptyAlert()
        }
    }
    
    // ウェブビュー表示用メソッド
    func showWebView(URL:String){
        // URLリクエストを作成
        var myURL = NSURL(string: URL)
        var myURLReq = NSURLRequest(URL: myURL!)
        // ウェブビューに表示する
        myWebView.loadRequest(myURLReq)
    }
    
    // ユーザーデフォルトに保存するメソッド
    func setUserDefault(data:String){
        var myDefault = NSUserDefaults.standardUserDefaults()
        myDefault.setObject(data, forKey: "URL")
        myDefault.synchronize()
    }
    
    // ユーザーデフォルトから読み出すメソッド
    func getUserDefault()->String{
        var myDefault = NSUserDefaults.standardUserDefaults()
        if var url:String = myDefault.stringForKey("URL"){
            return url
        } else {
            return ""
        }
    }
    
    // アラート表示用メソッド
    func emptyAlert(){
        var alertController = UIAlertController(
            title: "警告",
            message: "何か入力してください",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil
            )
        )
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 読込中の表示設定 //
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        SVProgressHUD.showWithStatus("読み込み中")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        SVProgressHUD.showSuccessWithStatus("成功!")
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.showErrorWithStatus("失敗!")
    }

}

