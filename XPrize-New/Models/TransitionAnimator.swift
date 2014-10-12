//
//  TransitionAnimator.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/2/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let reversed: Bool
    
    init(reversed: Bool) {
        self.reversed = reversed
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        animateTransition(transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!, fromVC: UIViewController!, toVC: UIViewController!, fromView: UIView!, toView: UIView!) {
        fatalError("animateTransition:fromVC:toVC: should not be called directly.")
    }
}

class IntroToSearchSymptomAnimator: TransitionAnimator {
    
    override func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.7
    }
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning!, fromVC: UIViewController!, toVC: UIViewController!, fromView: UIView!, toView: UIView!) {
        let containerView = transitionContext.containerView()
        containerView.insertSubview(toView, belowSubview: fromView)
        
        if reversed {
            let toViewController: IntroViewController = toVC as IntroViewController
            toViewController.setViewControllerState(.AfterEaseOut, animateDuration: 0, delay: 0, completion: nil)

            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                fromView.alpha = 0
            }, completion: { (_) -> Void in
                toViewController.setViewControllerState(.Normal, animateDuration: self.transitionDuration(transitionContext) - 0.4, delay: 0, completion: {
                    fromView.alpha = 1
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            })
        } else {
            let fromViewController: IntroViewController = fromVC as IntroViewController
            fromViewController.setViewControllerState(.AfterEaseOut, animateDuration: transitionDuration(transitionContext) - 0.4, delay: 0, completion: {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
                    fromView.alpha = 0
                }, completion: { (_) -> Void in
                    fromView.alpha = 1
                    fromViewController.diagnoseButton.alpha = 1
                    fromViewController.historyButton.alpha = 1
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            })
        }
    }
}
