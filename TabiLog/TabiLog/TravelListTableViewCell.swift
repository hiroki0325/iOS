//
//  TravelListTableViewCell.swift
//  TabiLog
//
//  Created by 島田洋輝 on 2016/02/18.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class TravelListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
