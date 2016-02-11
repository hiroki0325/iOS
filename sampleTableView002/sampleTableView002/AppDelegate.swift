//
//  AppDelegate.swift
//  sampleTableView002
//
//  Created by 島田洋輝 on 2016/02/05.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // データを配列で用意する
    var tea_list = [
        [
            "name":"ダージリン",
            "discription":"ダージリン・ティー (Darjeeling tea) は、インド北東部西ベンガル州北部のダージリン地方で生産される紅茶の総称である。時に「紅茶のシャンパン」とも呼ばれ、セイロンのウバ、中国のキーマンと並び世界の三大紅茶と称される。",
            "image":"darjeeling.jpg"
        ],
        [
            "name":"アールグレイ",
            "discription":"アールグレイとは、ベルガモットで柑橘系の香りをつけた紅茶で、フレーバーティーの一種。原料は中国茶のキーマン茶（祁門茶）が使われることが多いが、茶葉のブレンドは特に規定がないため、セイロン茶や、中国茶とセイロン茶のブレンド、稀にダージリンなども用いられる。Earl Grey とは「グレイ伯爵」の意であり、1830年代のイギリス首相、第二代グレイ伯チャールズ・グレイに由来する。アールグレイの販売会社は、ジャクソン社、トワイニング社、フォートナム・アンド・メイソン社がよく知られている。",
            "image":"earlgrey.jpg"
        ],
        [
            "name":"アッサム",
            "discription":"アッサムとは、インドのアッサム地方（インド北東部）でつくられる紅茶の総称である。19世紀初頭まで茶は東アジアに限定された作物とみなされていたが、1823年、アッサム地方に交易開拓に来たイギリス人・ロバート・ブルースが野生茶樹を発見した。この植物は最初、独立種として記載され後にチャノキ（学名 : Camellia sinensis (L.) Kuntze）の変種として再記載された。これが高木になる変種のアッサムチャである。この発見がアッサムでの茶栽培のきっかけである。アッサムチャは基本変種よりも寒さに弱い反面、低緯度地域あるいは低高度地域での栽培に向いている。1839年（1838年という説もある）、イギリスにはじめて輸出され、以降インド紅茶を代表する紅茶としての地位を確立した。ちなみにダージリンは中国から導入された基本変種であるチャノキ（学名 : Camellia sinensis (L.) Kuntze）をインドで栽培したものである。アッサムの紅茶は水色が濃い紅色でこくが強いためミルクティーとして飲まれることが多い。チャイ用として細かく丸まったCTC製法（Crush Tear Curl－－つぶして、ひきさいて、丸める）で製茶されたものが多く出回っている。",
            "image":"assam.jpg"
        ],
        [
            "name":"オレンジペコ",
            "discription":"オレンジ・ペコーまたはオレンジ・ピコーは、紅茶の茶葉の等級区分の一つ。",
            "image":"orangepekoe.jpg"
        ]
    ]

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
    }


}

