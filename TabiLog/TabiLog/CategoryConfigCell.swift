//
//  CustomCell.swift
//  sampleCollectionView
//
//  Created by 島田洋輝 on 2016/02/12.
//  Copyright © 2016年 Hiroki Shimada. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categorySwitch: UISwitch!
    @IBOutlet weak var categoryTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}