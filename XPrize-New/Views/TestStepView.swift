//
//  TestStepView.swift
//  XPrize-New
//
//  Created by Sihao Lu on 10/4/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit
import QuartzCore

protocol TestStepDelegate {
    func testStepViewReadyButtonTapped(sender: TestStepView)
}

class TestStepView: UIView {

    enum ImageSizingMode {
        case FixedWidth(CGFloat)
        case ExplicitWidthAndHeight(CGFloat, CGFloat)
    }
    
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var stepCounterLabel: UILabel!
    @IBOutlet var stepCounterLabelWidthConstraint: NSLayoutConstraint!
    var readyButton: UIButton?
    var delegate: TestStepDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func stepViewWithTest(test: DiagnoseTest, step: Int, superViewColor: UIColor?) -> TestStepView {
        return stepViewWithTest(test, step: step, imageSizingMode: .FixedWidth(160), superViewColor: superViewColor)
    }

    class func stepViewWithTest(test: DiagnoseTest, step: Int, imageSizingMode: ImageSizingMode, superViewColor: UIColor?) -> TestStepView {
        let view = NSBundle.mainBundle().loadNibNamed("TestStepView", owner: nil, options: nil).last! as TestStepView
        view.imageView.image = test.imageAtStep(step)
        if let image = view.imageView.image {
            switch imageSizingMode {
            case .FixedWidth(let width):
                view.imageWidthConstraint.constant = width
                view.imageHeightConstraint.constant = image.size.height / image.size.width * width
            case .ExplicitWidthAndHeight(let width, let height):
                view.imageWidthConstraint.constant = width
                view.imageHeightConstraint.constant = height
            }
        }
        view.descriptionLabel.text = test.steps[step]
        view.stepCounterLabel.text = "      STEP \(step + 1)"
        if test.steps.count == step + 1 {
            // Last step: should have a ready button
            view.readyButton = (UIButton.buttonWithType(UIButtonType.System) as UIButton)
            view.addSubview(view.readyButton!)
            layout(view.readyButton!, view.stepCounterLabel) { button, label in
                button.width == 110
                button.right == button.superview!.right + 20
                button.height == label.height
                button.centerY == label.centerY
            }
        }
        view.setupViews(superViewColor)
        return view
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func readyButtonTapped(sender: UIButton!) {
        delegate?.testStepViewReadyButtonTapped(self)
    }
    
    func setupViews(superViewColor: UIColor?) {
        descriptionLabel.textColor = DefaultTheme.pureTextColor
        readyButton?.setTitleColor(superViewColor, forState: .Normal)
        readyButton?.setTitleColor(superViewColor?.colorAfterAddingHueWithAngle(-30), forState: .Highlighted)
        readyButton?.setTitle("READY!     ", forState: .Normal)
        readyButton?.titleLabel!.font = UIFont.aezonTitleFontOfSize(22)
        readyButton?.addTarget(self, action: "readyButtonTapped:", forControlEvents: .TouchUpInside)
        stepCounterLabel.textColor = superViewColor
        stepCounterLabel.backgroundColor = DefaultTheme.pureColor
        readyButton?.backgroundColor = DefaultTheme.pureColor
        backgroundColor = UIColor.clearColor()
        imageView.tintColor = DefaultTheme.pureColor
        let mockLabel = UILabel()
        mockLabel.text = stepCounterLabel.text
        mockLabel.font = stepCounterLabel.font
        mockLabel.sizeToFit()
        stepCounterLabelWidthConstraint.constant = mockLabel.bounds.width + 15
        stepCounterLabel.layer.masksToBounds = true
        readyButton?.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stepCounterLabel.layer.cornerRadius = min(stepCounterLabel.bounds.width / 2, stepCounterLabel.bounds.height / 2)
        if readyButton != nil {
            readyButton!.layer.cornerRadius = min(readyButton!.bounds.width / 2, readyButton!.bounds.height / 2)
        }
    }
    
}
