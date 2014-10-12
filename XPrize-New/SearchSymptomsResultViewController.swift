//
//  SearchSymptomsResultViewController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/16/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class SearchSymptomsResultViewController: UITableViewController, UISearchResultsUpdating, SymptomTableViewCellDelegate, SymptomDetailViewControllerDelegate {

    let symptomCellIdentifier = "symptomCell"
    let symptomDetailSegueIdentifier = "symptomDetailSegue"
    var searchResults = [Symptom]()

    override func awakeFromNib() {
        tableView.separatorColor = UIColor.clearColor()
        UINavigationBar.appearance().shadowImage = UIImage()
        tableView.registerNib(UINib(nibName: "SymptomTableViewCell", bundle: nil)!, forCellReuseIdentifier: symptomCellIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return searchResults.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SymptomTableViewCell.heightOfCellWithBody(searchResults[indexPath.row].brief)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(symptomCellIdentifier, forIndexPath: indexPath) as SymptomTableViewCell
        // Configure the cell...
        cell.titleLabel.text = searchResults[indexPath.row].name
        cell.bodyLabel.text = searchResults[indexPath.row].brief ?? ""
        cell.chosen = searchResults[indexPath.row].chosen
        cell.delegate = self
        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(searchResults.count) RESULTS"
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.whiteColor()
        let header = view as UITableViewHeaderFooterView
        header.textLabel.textColor = DefaultTheme.darkTextColor
        header.textLabel.font = UIFont.aezonTitleFontOfSize(20)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(symptomDetailSegueIdentifier, sender: indexPath)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == symptomDetailSegueIdentifier {
            let indexPath = sender as NSIndexPath
            let detailVC = segue.destinationViewController as SymptomDetailViewController
            detailVC.symptom = searchResults[indexPath.row]
            detailVC.sourceViewController = self
        }
    }


    // MARK: Search Result Updating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text

        searchResults.removeAll(keepCapacity: false)
        self.tableView.beginUpdates()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.None)
        self.tableView.endUpdates()

        Doctor.sharedDoctor.searchSymptomWithKeyword(searchString) { (symptoms, error) -> Void in
            if (error != nil) {
                return
            }
            self.searchResults += symptoms!

            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
            self.tableView.endUpdates()
        }
    }

    // MARK: Symptom cell delegate
    func symptomCellChosenToggled(chosen: Bool, cell: SymptomTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let symptom = searchResults[indexPath.row]
            if chosen {
                User.currentUser.addSymptom(symptom)
            } else {
                User.currentUser.removeSymptom(symptom)
            }
        }
    }

    // MARK: SymptomDetailViewControllerDelegate
    func symptomUpdated(symptom: Symptom) {
        if let index = find(searchResults, symptom) {
            tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Left)
            tableView.endUpdates()
            Doctor.sharedDoctor.searchController.hidesNavigationBarDuringPresentation = true
            Doctor.sharedDoctor.searchController.active = true
        }
    }

}
