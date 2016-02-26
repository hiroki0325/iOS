//
//  Payment.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/19.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import Foundation
import CoreData

class Payment: NSManagedObject {
    
    @NSManaged var categoryID: Int16
    @NSManaged var currencyID: Int16
    @NSManaged var date: NSDate
    @NSManaged var picturePath:String
    @NSManaged var price:Float
    @NSManaged var travelID:Int16
    
}