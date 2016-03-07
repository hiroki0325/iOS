//
//  CurrencyConfigCell.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/03/08.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}