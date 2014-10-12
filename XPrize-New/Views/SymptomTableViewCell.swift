//
//  SymptomTableViewCell.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/2/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

protocol SymptomTableViewCellDelegate: NSObjectProtocol {
    func symptomCellChosenToggled(chosen: Bool, cell: SymptomTableViewCell)
}

class SymptomTableViewCell: StylishTableViewCell {
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var titleLabelLeftConstraint: NSLayoutConstraint!
    weak var delegate: SymptomTableViewCellDelegate?
    
    private var chosenColor: UIColor {
        get {
            return mainColor.colorAfterAddingHueWithAngle(-30)
        }
    }

    var allowToggle: Bool = true {
        didSet {
            if self.allowToggle {
                titleLabelLeftConstraint.constant = 54
                toggleButton.hidden = false
                mainColor = DefaultTheme.mainColor
            } else {
                titleLabelLeftConstraint.constant = 24
                toggleButton.hidden = true
                mainColor = DefaultTheme.mainColor.colorAfterAddingHueWithAngle(-30)
            }
            setColorInverted(false, animated: false)
        }
    }

    var chosen: Bool = false {
        didSet {
            setColorInverted(false, animated: false)
            let virusImage = UIImage(named: chosen ? "virus_highlight" : "virus")
            toggleButton.setBackgroundImage(virusImage, forState: .Normal)
        }
    }
    
    override func preloadCellFrameImages() {
        super.preloadCellFrameImages()
        let insets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        var coloredFrames = StylishCache.cellFrameCache[chosenColor]
        if coloredFrames == nil {
            coloredFrames = [String: UIImage]()
        }
        if coloredFrames!["cell_frame"] == nil {
            println("load cell frame")
            let cellFrameImage = UIImage(named: "cell_frame")!.tintedImageWithColor(chosenColor).resizableImageWithCapInsets(insets)
            coloredFrames!["cell_frame"] = cellFrameImage
        }
        if coloredFrames!["cell_frame_filled"] == nil {
            println("load cell frame filled")
            let cellFrameFilledImage = UIImage(named: "cell_frame_filled")!.tintedImageWithColor(chosenColor).resizableImageWithCapInsets(insets)
            coloredFrames!["cell_frame_filled"] = cellFrameFilledImage
        }
        StylishCache.cellFrameCache[chosenColor] = coloredFrames!
    }

    class func heightOfCellWithBody(body: String?) -> CGFloat {
        return heightOfCellWithBody(body, maxHeight: CGFloat(FLT_MAX))
    }

    class func heightOfCellWithBody(body: String?, maxHeight: CGFloat) -> CGFloat {
        let calculationView = UILabel()
        calculationView.text = body
        calculationView.font = UIFont.systemFontOfSize(13)
        calculationView.lineBreakMode = .ByWordWrapping
        calculationView.numberOfLines = 0
        let size = calculationView.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.width - 2 * 32, maxHeight))
        return size.height + 52
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        chosen = false
    }

    @IBAction func toggleCell() {
        chosen = !chosen
        delegate?.symptomCellChosenToggled(chosen, cell: self)
    }

    override func imageHighlighted(highlighted: Bool) -> UIImage {
        if !chosen {
            return super.imageHighlighted(highlighted)
        }
        if highlighted {
            return highlightedChosenFrameImage
        } else {
            return chosenFrameImage
        }
    }

    func textColorHighlighted(highlighted: Bool) -> UIColor {
        return highlighted ? DefaultTheme.darkTextColor : DefaultTheme.pureTextColor
    }

    func virusImageHighlighted(highlighted: Bool) -> UIImage {
        let virusImage = UIImage(named: chosen ? "virus_highlight" : "virus")!
        if !highlighted {
            return virusImage
        } else {
            return virusImage.tintedImageWithColor(chosen ? chosenColor: mainColor)
        }
    }

    override func setColorInverted(inverted: Bool, animated: Bool) {
        super.setColorInverted(inverted, animated: animated)
        toggleButton.setBackgroundImage(virusImageHighlighted(inverted), forState: .Normal)
        if !inverted {
            if animated {
                let bodyLabelCopy = UILabel(frame: bodyLabel.frame)
                bodyLabelCopy.textColor = textColorHighlighted(true)
                self.addSubview(bodyLabelCopy)
                UIView.animateWithDuration(animationDuration, animations: {
                    bodyLabelCopy.alpha = 0
                }, completion: {
                    _ in
                    bodyLabelCopy.removeFromSuperview()
                })
            }
            bodyLabel.textColor = textColorHighlighted(false)
        } else {
            if animated {
                let bodyLabelCopy = UILabel(frame: bodyLabel.frame)
                bodyLabelCopy.textColor = textColorHighlighted(false)
                self.addSubview(bodyLabelCopy)
                UIView.animateWithDuration(animationDuration, animations: {
                    bodyLabelCopy.alpha = 0
                    }, completion: {
                        _ in
                        bodyLabelCopy.removeFromSuperview()
                })
            }
            bodyLabel.textColor = textColorHighlighted(true)
        }
    }
}

extension SymptomTableViewCell {
    var chosenFrameImage: UIImage! {
        return StylishCache.cellFrameCache[chosenColor]?["cell_frame_filled"]
    }
    
    var highlightedChosenFrameImage: UIImage! {
        return StylishCache.cellFrameCache[chosenColor]?["cell_frame"]
    }
}

