//
//  RoundIconButtonView.swift
//  XPrize-New
//
//  Created by Sihao Lu on 8/31/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit
import QuartzCore

class RoundIconButtonView: UIView {
    private var buttonCenterYConstraint: NSLayoutConstraint!
    var button: UIButton!
    var buttonContainerView: UIView!
    var buttonTapHandler: ((RoundIconButtonView) -> Void)?
    var defaultColor, highlightColor, backgroundViewColor: UIColor!
    var titleLabel: UILabel!

    var normalIcon: UIImage!
    var highlightedIcon: UIImage!
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(title: String, icon: UIImage, theme: Style.Theme, buttonTapHandler: (RoundIconButtonView) -> Void) {
        // The initial width and height must be equal to or larger than the inset
        self.init(frame: CGRectMake(0, 0, 6, 6))
        setupView()
        self.title = title
        self.defaultColor = theme.mainColor
        self.highlightColor = theme.pureColor
        self.backgroundViewColor = theme.mainColor
        buttonContainerView.backgroundColor = defaultColor
        button.backgroundColor = defaultColor
        normalIcon = icon.tintedImageWithColor(highlightColor)
        highlightedIcon = icon.tintedImageWithColor(backgroundViewColor)
        button.setImage(normalIcon, forState: .Normal)
        button.setImage(highlightedIcon, forState: .Highlighted)
        titleLabel.textColor = defaultColor
        self.buttonTapHandler = buttonTapHandler
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = min(button.bounds.width / 2, button.bounds.height / 2)
        buttonContainerView.layer.cornerRadius = min(buttonContainerView.bounds.width / 2, buttonContainerView.bounds.height / 2)
    }
    
    func setupView() {
        clipsToBounds = false
        buttonContainerView = UIView(frame: CGRectZero)
        self.addSubview(buttonContainerView)
        button = UIButton(frame: CGRectZero)
        button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchDown | .TouchDragEnter)
        button.addTarget(self, action: "buttonReleased:", forControlEvents: .TouchCancel | .TouchDragExit)
        buttonContainerView.addSubview(button)
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.font = UIFont.aezonLightFontOfSize(16)
        titleLabel.textAlignment = .Center
        self.addSubview(titleLabel)
        layout(buttonContainerView, titleLabel) {
            view, view2 in
            view.left == view.superview!.left
            view.right == view.superview!.right
            view.height == view.width
            self.buttonCenterYConstraint = (view.centerY == view.superview!.centerY)
            view2.top == view.bottom + 5
            view2.centerX == view2.superview!.centerX
            view2.width == view2.superview!.width
            view2.height == 20
        }
        layout(button) {
            view in
            view.width == view.superview!.width - 6
            view.height == view.width
            view.centerX == view.superview!.centerX
            view.centerY == view.superview!.centerY
        }
        titleLabel.alpha = 0
    }
    
    func buttonTapped(sender: UIButton) {
        buttonReleased(sender)
        buttonTapHandler?(self)
    }
    
    func buttonPressed(sender: UIButton) {
        button.backgroundColor = highlightColor
    }
    
    func buttonReleased(sender: UIButton) {
        button.backgroundColor = defaultColor
    }
    
    func showTitleAnimatedWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        self.buttonCenterYConstraint.constant = -12.5
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: {
            self.titleLabel.alpha = 1
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    func hideTitleAnimatedWithDuration(duration: NSTimeInterval, completion: ((Bool) -> Void)?) {
        self.buttonCenterYConstraint.constant = 0
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: {
            self.titleLabel.alpha = 0
            self.layoutIfNeeded()
        }, completion: completion)
    }
}

extension UIImage {
    func tintedImageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1, -1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        // draw alpha-mask
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        CGContextDrawImage(context, rect, self.CGImage)
    
        // draw tint color, preserving alpha values of original image
        CGContextSetBlendMode(context, kCGBlendModeSourceIn)
        tintColor.setFill()
        CGContextFillRect(context, rect)
    
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return coloredImage
    }
}
