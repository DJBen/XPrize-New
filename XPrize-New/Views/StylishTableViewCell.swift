//
//  StylishTableViewCell.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/19/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class StylishTableViewCell: UITableViewCell {

    @IBOutlet var frameView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    var animationDuration: NSTimeInterval = 0.25
    
    var mainColor: UIColor = DefaultTheme.mainColor {
        didSet(prevColor) {
            preloadCellFrameImages()
        }
    }
    
    func preloadCellFrameImages() {
        let insets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        var coloredFrames = StylishCache.cellFrameCache[mainColor]
        if coloredFrames == nil {
            coloredFrames = [String: UIImage]()
        }
        if coloredFrames!["cell_frame"] == nil {
            let cellFrameImage = UIImage(named: "cell_frame")!.tintedImageWithColor(mainColor).resizableImageWithCapInsets(insets)
            coloredFrames!["cell_frame"] = cellFrameImage
        }
        if coloredFrames!["cell_frame_filled"] == nil {
            let cellFrameFilledImage = UIImage(named: "cell_frame_filled")!.tintedImageWithColor(mainColor).resizableImageWithCapInsets(insets)
            coloredFrames!["cell_frame_filled"] = cellFrameFilledImage
        }
        StylishCache.cellFrameCache[mainColor] = coloredFrames!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clearColor()
        preloadCellFrameImages()
        setColorInverted(false, animated: false)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setColorInverted(highlighted, animated: highlighted)
    }

    func imageHighlighted(highlighted: Bool) -> UIImage {
        return highlighted ? cellFrameImage : cellFrameFilledImage
    }

    func titleTextColorHighlighted(highlighted: Bool) -> UIColor {
        return highlighted ? DefaultTheme.darkerTextColor : DefaultTheme.pureTextColor
    }

    func setColorInverted(inverted: Bool, animated: Bool) {
        if !inverted {
            if animated {
                let frameViewCopy = UIImageView(frame: frameView.frame)
                frameViewCopy.image = imageHighlighted(true)
                self.addSubview(frameViewCopy)
                let titleLabelCopy = UILabel(frame: titleLabel.frame)
                titleLabelCopy.textColor = titleTextColorHighlighted(true)
                self.addSubview(titleLabelCopy)
                UIView.animateWithDuration(animationDuration, animations: {
                    frameViewCopy.alpha = 0
                    titleLabelCopy.alpha = 0
                    }, completion: {
                        _ in
                        frameViewCopy.removeFromSuperview()
                        titleLabelCopy.removeFromSuperview()
                })
            }
            frameView.image = imageHighlighted(false)
            titleLabel.textColor = titleTextColorHighlighted(false)
        } else {
            if animated {
                let frameViewCopy = UIImageView(frame: frameView.frame)
                frameViewCopy.image = imageHighlighted(false)
                self.addSubview(frameViewCopy)
                let titleLabelCopy = UILabel(frame: titleLabel.frame)
                titleLabelCopy.textColor = titleTextColorHighlighted(false)
                self.addSubview(titleLabelCopy)
                UIView.animateWithDuration(animationDuration, animations: {
                    frameViewCopy.alpha = 0
                    titleLabelCopy.alpha = 0
                    }, completion: {
                        _ in
                        frameViewCopy.removeFromSuperview()
                        titleLabelCopy.removeFromSuperview()
                })
            }
            frameView.image = imageHighlighted(true)
            titleLabel.textColor = titleTextColorHighlighted(true)
        }
    }
}

let StylishCache = StylishTableViewCellCache.sharedCache

class StylishTableViewCellCache {
    class var sharedCache : StylishTableViewCellCache {
        struct Static {
            static let instance : StylishTableViewCellCache = StylishTableViewCellCache()
        }
        return Static.instance
    }
    
    var cellFrameCache = [UIColor: [String: UIImage]]()
}

extension StylishTableViewCell {
    var cellFrameImage: UIImage! {
        return StylishCache.cellFrameCache[mainColor]?["cell_frame"]
    }
    
    var cellFrameFilledImage: UIImage! {
        return StylishCache.cellFrameCache[mainColor]?["cell_frame_filled"]
    }
}
