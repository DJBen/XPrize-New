//
//  NavigationController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/2/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController!, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        if fromVC is IntroViewController && operation == .Push {
            return IntroToSearchSymptomAnimator(reversed: false)
        } else if fromVC is SearchSymptomsViewController && operation == .Pop {
            return IntroToSearchSymptomAnimator(reversed: true)
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
