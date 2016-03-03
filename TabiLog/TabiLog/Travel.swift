//
//  Travel.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/16.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import Foundation
import CoreData

class Travel: NSManagedObject {

    @NSManaged var budget: Float
    @NSManaged var destination: String
    @NSManaged var from: NSDate
    @NSManaged var to: NSDate
    @NSManaged var budgetCurrencyID: Int16
    @NSManaged var deleteFlg: NSNumber?
    @NSManaged var id: Int16
    
}
