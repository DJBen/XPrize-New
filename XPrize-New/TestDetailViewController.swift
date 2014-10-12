//
//  TestDetailViewController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 10/4/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class TestDetailViewController: UIViewController, UIScrollViewDelegate, TestStepDelegate {
    
    var test: DiagnoseTest!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var testNameLabel: UILabel!
    
    var testStepViews = [TestStepView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController!.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        view.backgroundColor = DefaultTheme.mainColor.colorAfterAddingHueWithAngle(-90)
        testNameLabel.text = test.name
        testNameLabel.textColor = DefaultTheme.pureColor
        pageControl.numberOfPages = test.steps.count
        for i in 0..<test.steps.count {
            let testView = TestStepView.stepViewWithTest(test, step: i, superViewColor: view.backgroundColor)
            testStepViews.append(testView)
        }
        scrollView.contentSize.width = CGFloat(testStepViews.count) * UIScreen.mainScreen().bounds.width
        var i = 0
        for testStepView in testStepViews {
            testStepView.delegate = self
            scrollView.addSubview(testStepView)
            let xOffset = CGFloat(i) * UIScreen.mainScreen().bounds.width
            layout(testStepView) { stepView in
                stepView.width == stepView.superview!.width
                stepView.height == stepView.superview!.height
                stepView.left == stepView.superview!.left + Float(xOffset)
                stepView.centerY == stepView.superview!.centerY
            }
            i++
        }
    }
    
    // MARK: Scroll view delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / UIScreen.mainScreen().bounds.width
        pageControl.currentPage = Int(page)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Test Step view delegate
    func testStepViewReadyButtonTapped(sender: TestStepView) {
        let alert = UIAlertController(title: "Start Testing", message: "Do you follow the instructions correctly and agree to start the next phase of testing?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Test", style: .Default) { (action) -> Void in
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

}
