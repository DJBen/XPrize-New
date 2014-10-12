//
//  TestItemTableViewCell.swift
//  XPrize-New
//
//  Created by Sihao Lu on 10/3/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class TestItemTableViewCell: StylishTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainColor = DefaultTheme.mainColor.colorAfterAddingHueWithAngle(-90)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
