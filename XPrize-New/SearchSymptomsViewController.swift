//
//  SearchSymptomsViewController.swift
//  XPrize-New
//
//  Created by Sihao Lu on 9/1/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

class SearchSymptomsViewController: UITableViewController, UISearchControllerDelegate, SymptomDetailViewControllerDelegate {

    let suggestionCellIdentifier = "suggestionCell"
    let emptySymptomCellIdentifier = "emptySymptomCell"
    let symptomCellIdentifier = "symptomCell"
    let searchSymptomResultVCIdentifier = "searchSymptomResult"
    let symptomDetailSegueIdentifier = "symptomDetailSegue_search"
    var searchSymptomsResultVC: SearchSymptomsResultViewController!

    var suggestionCount = [String: Int]()

    override func awakeFromNib() {
        tableView.registerNib(UINib(nibName: "SymptomTableViewCell", bundle: nil)!, forCellReuseIdentifier: symptomCellIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadSuggestionCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadSuggestionCount() {
       var shouldSearch = false
       for index in 0..<Doctor.suggestedSymptomKeywords.count {
           let symptomKeyword = Doctor.suggestedSymptomKeywords[index]
           if self.suggestionCount[symptomKeyword] == nil {
               shouldSearch = true
               break
           }
       }
       if !shouldSearch {
           return
       }
       Doctor.sharedDoctor.searchBatchSymptomsWithKeywords(Doctor.suggestedSymptomKeywords, completion: { (allSymptoms, error) -> Void in
           println("\(allSymptoms.count) searches.")
           for (symptomKeyword, symptoms) in allSymptoms {
               self.suggestionCount[symptomKeyword] = symptoms.count
           }
           self.tableView.beginUpdates()
           self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Left)
           self.tableView.endUpdates()
       })
    }
    
    private func setupViews() {
//        for subview in searchBar.subviews {
//            for secondLevelSubView in subview.subviews {
//                if let textField = secondLevelSubView as? UITextField {
//                    textField.textColor = Style.leftColors().mainColor
//                }
//            }
//        }

        searchSymptomsResultVC = storyboard!.instantiateViewControllerWithIdentifier(searchSymptomResultVCIdentifier) as SearchSymptomsResultViewController
        Doctor.sharedDoctor.searchController = UISearchController(searchResultsController: searchSymptomsResultVC)
        Doctor.sharedDoctor.searchController.searchResultsUpdater = searchSymptomsResultVC
        let searchBar = Doctor.sharedDoctor.searchController.searchBar
        Doctor.sharedDoctor.searchController.searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, searchBar.frame.size.width, 44.0)
        Doctor.sharedDoctor.searchController.searchBar.placeholder = "Type symptoms here"
        Doctor.sharedDoctor.searchController.searchBar.barTintColor = UIColor.whiteColor()
        Doctor.sharedDoctor.searchController.searchBar.tintColor = DefaultTheme.mainColor
        Doctor.sharedDoctor.searchController.searchBar.backgroundImage = UIImage()
        Doctor.sharedDoctor.searchController.delegate = self
        tableView.tableHeaderView = Doctor.sharedDoctor.searchController.searchBar
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0 {
            return User.currentUser.symptoms.count > 0 ? User.currentUser.symptoms.count : 1
        } else {
            return Doctor.suggestedSymptomKeywords.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if User.currentUser.symptoms.count == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(emptySymptomCellIdentifier, forIndexPath: indexPath) as EmptySymptomTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(symptomCellIdentifier, forIndexPath: indexPath) as SymptomTableViewCell
                let symptom = User.currentUser.symptoms[indexPath.row]
                cell.allowToggle = false
                cell.titleLabel.text = symptom.name
                cell.bodyLabel.text = symptom.brief
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(suggestionCellIdentifier, forIndexPath: indexPath) as SymptomSuggestionTableViewCell
            let symptomKeyword = Doctor.suggestedSymptomKeywords[indexPath.row]
            cell.titleLabel.text = symptomKeyword
            if let suggestionCount = self.suggestionCount[symptomKeyword] {
                cell.foundInfoLabel.text = "\(suggestionCount) Found"
            } else {
                cell.foundInfoLabel.text = "0 Found"
            }
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if User.currentUser.symptoms.count == 0 {
                return 75
            }
            return SymptomTableViewCell.heightOfCellWithBody(User.currentUser.symptoms[indexPath.row].brief, maxHeight: 120)
        }
        return 54
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 && User.currentUser.symptoms.count > 0 {
            performSegueWithIdentifier(symptomDetailSegueIdentifier, sender: indexPath)
        } else if indexPath.section == 1 {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
            Doctor.sharedDoctor.searchController.searchBar.text = Doctor.suggestedSymptomKeywords[indexPath.row]
            Doctor.sharedDoctor.searchController.active = true
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["My symptoms", "Recommended searches"][section]
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.whiteColor()
        let header = view as UITableViewHeaderFooterView
        header.textLabel.textColor = DefaultTheme.darkTextColor
        header.textLabel.font = UIFont.aezonTitleFontOfSize(20)
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
        return indexPath.section == 0 && User.currentUser.symptoms.count != 0
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let symptom = User.currentUser.symptoms[indexPath.row]
            User.currentUser.removeSymptom(symptom)
            if User.currentUser.symptoms.count == 0 {
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == symptomDetailSegueIdentifier {
            let indexPath = sender as NSIndexPath
            let detailVC = segue.destinationViewController as SymptomDetailViewController
            detailVC.symptom = User.currentUser.symptoms[indexPath.row]
            detailVC.sourceViewController = self
        }
    }

    func didDismissSearchController(searchController: UISearchController) {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Left)
        tableView.endUpdates()
    }

    // MARK: Symptom Detail Delegate
    func symptomUpdated(symptom: Symptom) {
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Left)
        tableView.endUpdates()
    }
}
