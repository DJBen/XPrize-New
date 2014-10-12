//
//  TestListViewController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 10/3/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

let testItemCellIdentifier = "testCell"
let testDetailSegueName = "testDetailSegue"

class TestListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DiagnoseTest.preloadDataFileWithPath(NSBundle.mainBundle().pathForResource("lab_tests", ofType: "plist")!)
        Doctor.sharedDoctor.diagnoseUser(User.currentUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindFromTestDetail(sender: UIStoryboardSegue!) {
        navigationController!.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - UITableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.currentUser.tests.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(testItemCellIdentifier, forIndexPath: indexPath) as TestItemTableViewCell
        let test = User.currentUser.tests[indexPath.row]
        cell.titleLabel.text = test.name
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == testDetailSegueName {
            if let senderCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPathForCell(senderCell)!
                let test = User.currentUser.tests[indexPath.row]
                let destinationVC = segue.destinationViewController as TestDetailViewController
                destinationVC.test = test
            }
        }
    }


}
