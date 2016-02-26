//
//  Currency.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/25.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import Foundation
import CoreData

class Currency: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var rate: Double
    @NSManaged var useFlg: NSNumber?
    @NSManaged var travelID:Int16
    @NSManaged var currencyID:Int16
    
}