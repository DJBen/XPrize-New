//
//  SearchSymptomEmptyView.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/19/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class SearchSymptomEmptyView: UIView {
    
    var label: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    func setupViews() {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.aezonMediumFontOfSize(18)
        label.textColor = DefaultTheme.darkTextColor
        label.text = "No results found"
        addSubview(label)
        layout(label) {
            view in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    
}
