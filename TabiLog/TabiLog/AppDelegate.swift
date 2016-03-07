//
//  AppDelegate.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let myDefault = NSUserDefaults.standardUserDefaults()

    var travelID:Int = 0
    var period:String = ""
    var direction:String = ""
    var defaultCurrency:NSMutableArray = [["name":"円","rate":1], ["name":"ドル","rate":0.00881,"code":"USD"], ["name":"ユーロ","rate":0.00804,"code":"EUR"], ["name":"元","rate":0.05742,"code":"CNY"], ["name":"ウォン","rate":10.61915,"code":"KRW"],["name":"ポンド","rate":0.00622,"code":"GBP"],["name":"香港ドル","rate":0.06843,"code":"HKD"],["name":"台湾ドル","rate":0.2882,"code":"TWD"],["name":"シンガポールドル","rate":0.01217,"code":"SGD"],["name":"オーストラリアドル","rate":0.01187,"code":"AUD"],["name":"カナダドル","rate":0.01177,"code":"CAD"],["name":"インドルピー","rate":0.5919,"code":"INR"],["name":"ペソ","rate":0.41336,"code":"PHP"],["name":"ドン","rate":196.39563,"code":"VND"],["name":"バーツ","rate":0.31184,"code":"THB"],["name":"ルピア","rate":115.17704,"code":"IDR"],["name":"リンギット","rate":0.03604,"code":"MYR"]]
    var defaultCategory = [["ID":1,"name":"食費","deleteFlg":0,],["ID":2,"name":"交通費","deleteFlg":0],["ID":3,"name":"日用品","deleteFlg":0],["ID":4,"name":"宿泊費","deleteFlg":0],["ID":5,"name":"娯楽費","deleteFlg":0],["ID":6,"name":"通信料","deleteFlg":0],["ID":100,"name":"その他","deleteFlg":0]]
    var currencyList:[NSDictionary] = []
    var categoryList = []
    var travelDetail:[NSDictionary] = []
    var travelNum:Int = 0
    var managedObjects:[NSManagedObject] = []
    var travelIDs:[Int] = []
    var nextTravelID:Int = 0
    var nextCategoryID = 5
    var lastCurrencyID:Int = -1
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if myDefault.integerForKey("nextTravelID") == 0 {
            myDefault.setInteger(self.nextTravelID, forKey: "nextTravelID")
            myDefault.setInteger(self.lastCurrencyID, forKey: "lastCurrencyID")
            myDefault.setInteger(self.nextCategoryID, forKey: "nextCategoryID")
            myDefault.setObject(self.defaultCategory, forKey: "category")
            myDefault.synchronize()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // NSDateをフォーマットして返す（年月日）
    func getDateFormat(date: NSDate = NSDate()) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        return dateFormatter.stringFromDate(date)
    }
    // NSDateをフォーマットして返す（月日）
    func getDateFormat2(date: NSDate = NSDate()) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.stringFromDate(date)
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hirokishimada.TabiLog" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("TabiLog", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // すでに存在する旅行データの読み込み処理(削除されていないもののみ)
    func readTravel() {
        // データの初期化
        self.travelDetail = []
        
        // Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        let managedObjectContext = self.managedObjectContext
        
        // Entityを指定する設定
        let entityDiscription = NSEntityDescription.entityForName("Travel", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Travel")
        fetchRequest.entity = entityDiscription
        let predicate = NSPredicate(format: "%K = %d", "deleteFlg", 0)
        fetchRequest.predicate = predicate
        
        // errorが発生した際にキャッチするための変数
        var error: NSError? = nil
        
        // フェッチリクエスト (データの検索と取得処理) の実行
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.travelNum = results.count
            self.travelIDs = []
            self.managedObjects = []
            for managedObject in results {
                self.managedObjects.append(managedObject as! NSManagedObject)
                let travel = managedObject as! Travel
                self.travelIDs.append(Int(travel.id))
                var newTravel:NSDictionary =
                [
                    "id":Int(travel.id),
                    "destination":travel.destination,
                    "from":travel.from,
                    "to":travel.to,
                    "budget":travel.budget
                ]
                self.travelDetail.append(newTravel)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    // すでに存在する通貨データの読み込み処理
    func readCurrency() {
        self.currencyList = []
        let managedObjectContext = self.managedObjectContext
        let entityDiscription = NSEntityDescription.entityForName("Currency", inManagedObjectContext: managedObjectContext)
        let fetchRequest = NSFetchRequest(entityName: "Currency")
        fetchRequest.entity = entityDiscription
        let predicate = NSPredicate(format: "%K = %d", "travelID", self.travelID)
        fetchRequest.predicate = predicate
        var error: NSError? = nil
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let currency = managedObject as! Currency
                var newCurrency:NSDictionary =
                [
                    "name":currency.name,
                    "rate":currency.rate,
                    "useFlg":currency.useFlg!
                ]
                self.currencyList.append(newCurrency)
            }
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    func readCategoryList(){
        self.categoryList = NSMutableArray(array: myDefault.arrayForKey("category")!)
    }
    
    func updateCurrencyLate(){
        var url = "http://api.aoikujira.com/kawase/json/jpy"
        var URL = NSURL(string: url)
        var request = NSURLRequest(URL: URL!)
        do {
            var jsondata = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            var jsonDictionary = try NSJSONSerialization.JSONObjectWithData(jsondata, options: []) as! NSDictionary
            for(var i=1; self.defaultCurrency.count>i; i++){
                var tmpCurrencyList = NSMutableDictionary(dictionary: self.defaultCurrency[i] as! [NSObject : AnyObject])
                tmpCurrencyList["rate"] = Double(jsonDictionary[self.defaultCurrency[i]["code"] as! String] as! String)
                self.defaultCurrency[i] = tmpCurrencyList
            }
        } catch {
        }
        
    }
    
    func getnextTravelID(){
        self.nextTravelID = myDefault.integerForKey("nextTravelID")
    }
    
    func getnextCategoryID(){
        self.nextCategoryID = myDefault.integerForKey("nextCategoryID")
    }
    
}