//
//  SymptomSuggestionTableViewCell.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/19/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class SymptomSuggestionTableViewCell: StylishTableViewCell {

    @IBOutlet var foundInfoLabel: UILabel!

    override func setColorInverted(inverted: Bool, animated: Bool) {
        super.setColorInverted(inverted, animated: animated)
        func textColorHighlighted(highlighted: Bool) -> UIColor {
            return highlighted ? DefaultTheme.darkTextColor : DefaultTheme.pureTextColor
        }
        if !inverted {
            if animated {
                let findInfoLabelCopy = UILabel(frame: foundInfoLabel.frame)
                findInfoLabelCopy.textColor = textColorHighlighted(true)
                self.addSubview(findInfoLabelCopy)
                UIView.animateWithDuration(animationDuration, animations: {
                    findInfoLabelCopy.alpha = 0
                    }, completion: {
                        _ in
                        findInfoLabelCopy.removeFromSuperview()
                })
            }
            foundInfoLabel.textColor = textColorHighlighted(false)
        } else {
            if animated {
                let findInfoLabelCopy = UILabel(frame: foundInfoLabel.frame)
                findInfoLabelCopy.textColor = textColorHighlighted(false)
                self.addSubview(findInfoLabelCopy)
                UIView.animateWithDuration(animationDuration, animations: {
                    findInfoLabelCopy.alpha = 0
                    }, completion: {
                        _ in
                        findInfoLabelCopy.removeFromSuperview()
                })
            }
            foundInfoLabel.textColor = textColorHighlighted(true)
        }
    }

}
