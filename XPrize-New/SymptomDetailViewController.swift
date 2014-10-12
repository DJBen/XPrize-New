//
//  SymptomDetailViewController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 10/1/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit
import QuartzCore

protocol SymptomDetailViewControllerDelegate {
    func symptomUpdated(symptom: Symptom)
}

class SymptomDetailViewController: UIViewController {

    var symptom: Symptom!
    var sourceViewController: SymptomDetailViewControllerDelegate?
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var toggleSymptomButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    var ringView: UIView!

    var color: UIColor = DefaultTheme.mainColor {
        didSet {
            self.topView.backgroundColor = self.color
            self.ringView.backgroundColor = topView.backgroundColor
            self.bottomView.backgroundColor = DefaultTheme.pureColor
            self.toggleSymptomButton.backgroundColor = DefaultTheme.pureColor
            self.titleLabel.textColor = DefaultTheme.pureTextColor
            self.descriptionLabel.textColor = DefaultTheme.darkTextColor
            self.toggleSymptomButton.setTitleColor(DefaultTheme.mainColor, forState: .Normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        ringView.layer.cornerRadius = min(ringView.bounds.width, ringView.bounds.height) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupViews() {
        ringView = UIView(frame: CGRectZero)
        view.insertSubview(ringView, belowSubview: toggleSymptomButton)
        layout(ringView, toggleSymptomButton) { ring, button in
            ring.height == button.height + 4
            ring.width == button.width + 4
            ring.centerX == button.centerX
            ring.centerY == button.centerY
        }
        heightConstraint.constant = UIScreen.mainScreen().bounds.height * 0.55
        let chosen = symptom.chosen
        color = colorForChosen(chosen)
        titleLabel.text = symptom.name
        toggleSymptomButton.setTitle(chosen ? "I DON'T HAVE" : "I HAVE", forState: .Normal)
        descriptionLabel.text = symptom.brief ?? "No description available"
        toggleSymptomButton.titleLabel!.textAlignment = .Center
    }

    @IBAction func toggleSymptomButtonTapped(sender: UIButton!) {
        symptom.chosen = !symptom.chosen
        let chosen = symptom.chosen
        color = colorForChosen(chosen)
        toggleSymptomButton.setTitle(chosen ? "I DON'T HAVE" : "I HAVE", forState: .Normal)
    }

    @IBAction func closeButtonTapped(sender: UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
        sourceViewController?.symptomUpdated(symptom)
    }

    private func colorForChosen(chosen: Bool) -> UIColor {
        if chosen {
            return DefaultTheme.mainColor.colorAfterAddingHueWithAngle(-30)
        } else {
            return DefaultTheme.mainColor
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
