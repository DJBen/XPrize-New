//
//  IntroViewController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 8/31/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIViewControllerTransitioningDelegate {
    enum ViewControllerState {
        case BeforeEaseIn
        case Normal
        case AfterEaseOut
    }
    
    let diagnoseSegueName = "diagnoseSegue"
    
    var state: ViewControllerState = .BeforeEaseIn
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleBackgroundView: UIView!
    var buttonBackgroundView: UIView!
    var titleBackgroundViewBottomConstraint: NSLayoutConstraint!
    var diagnoseButton: RoundIconButtonView!
    var historyButton: RoundIconButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBarHidden = true
        setupViews()
        setupColors()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupColors() {
        titleLabel.textColor = DefaultTheme.pureTextColor
        buttonBackgroundView.backgroundColor = DefaultTheme.pureColor
        titleBackgroundView.backgroundColor = DefaultTheme.mainColor
    }
    
    private func setupViews() {
        buttonBackgroundView = UIView(frame: CGRectZero)
        buttonBackgroundView.clipsToBounds = true
        self.view.addSubview(buttonBackgroundView)
        diagnoseButton = RoundIconButtonView(title: "Diagnose", icon: UIImage(named: "Diagnosis")!, theme: DefaultTheme, {
            button in
            self.performSegueWithIdentifier(self.diagnoseSegueName, sender: button)
        })
        historyButton = RoundIconButtonView(title: "History", icon: UIImage(named: "History")!, theme: DefaultTheme, buttonTapHandler: {
            button in
        })
        buttonBackgroundView.addSubview(diagnoseButton)
        buttonBackgroundView.addSubview(historyButton)
        layout(buttonBackgroundView, titleBackgroundView) {
            view, view2 in
            view.left == view.superview!.left
            view.bottom == view.superview!.bottom
            view.right == view.superview!.right
            self.titleBackgroundViewBottomConstraint = (view2.bottom == view2.superview!.bottom)
            view.top == view2.bottom
        }
        diagnoseButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        historyButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        layout(diagnoseButton, historyButton) {
            leftButton, rightButton in
            leftButton.centerX == leftButton.superview!.centerX - 70
            rightButton.centerX == rightButton.superview!.centerX + 70
            leftButton.width == 90
            leftButton.height == leftButton.width
            rightButton.width == leftButton.width
            rightButton.height == rightButton.width
            leftButton.centerY == leftButton.superview!.centerY
            rightButton.centerY == leftButton.centerY
        }
        
        // Animation: Ease in the buttons
        setViewControllerState(.Normal, animateDuration: 2, delay: 0.8, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == diagnoseSegueName {
            let searchSymptomVC = segue.destinationViewController as SearchSymptomsViewController
            searchSymptomVC.transitioningDelegate = self
            navigationController!.setNavigationBarHidden(false, animated: true)
        }
    }
    
    private func setConstraintsToViewControllerState(state: ViewControllerState) {
        self.view.removeConstraint(titleBackgroundViewBottomConstraint)
        switch state {
        case .BeforeEaseIn:
            titleBackgroundViewBottomConstraint = NSLayoutConstraint(item: titleBackgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        case .Normal:
            titleBackgroundViewBottomConstraint = NSLayoutConstraint(item: titleBackgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 2 * 0.618, constant: 0)
        case .AfterEaseOut:
            titleBackgroundViewBottomConstraint = NSLayoutConstraint(item: titleBackgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        }
        self.view.addConstraint(titleBackgroundViewBottomConstraint)
    }
    
    func setViewControllerState(newState: ViewControllerState, animateDuration: NSTimeInterval, delay: NSTimeInterval, completion: (() -> Void)?) {
        if self.state == newState {
            return
        }
        setConstraintsToViewControllerState(newState)
        self.state = newState
        var afterAction: ((Bool, (() -> Void)?) -> Void)!
        var afterAnimationTimePercentage: NSTimeInterval!
        switch newState {
        case .BeforeEaseIn:
            afterAnimationTimePercentage = 0.35
            afterAction = {
                _, completion in
                self.diagnoseButton.hideTitleAnimatedWithDuration(animateDuration * afterAnimationTimePercentage, completion: nil)
                self.historyButton.hideTitleAnimatedWithDuration(animateDuration * afterAnimationTimePercentage, completion: {
                    _ in
                    if completion != nil {
                        completion!()
                    }
                })
            }
        case .Normal:
            afterAnimationTimePercentage = 0.35
            afterAction = {
                _, completion in
                self.diagnoseButton.showTitleAnimatedWithDuration(animateDuration * afterAnimationTimePercentage, completion: nil)
                self.historyButton.showTitleAnimatedWithDuration(animateDuration * afterAnimationTimePercentage, completion: {
                    _ in
                    if completion != nil {
                        completion!()
                    }
                })
            }
        case .AfterEaseOut:
            afterAnimationTimePercentage = 0.35
            afterAction = {
                _, completion in
                UIView.animateKeyframesWithDuration(animateDuration * afterAnimationTimePercentage, delay: 0, options: nil, animations: {
                    self.diagnoseButton.alpha = 0
                    self.historyButton.alpha = 0
                }, completion: {
                    _ in
                    if completion != nil {
                        completion!()
                    }
                })
            }
        }
        UIView.animateWithDuration(animateDuration * (1 - afterAnimationTimePercentage), delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            finished in
            afterAction(finished, completion)
        })
    }
}

