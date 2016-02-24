//
//  CheckAccountViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/20/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class CheckAccountViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var summaryTitleLabel: UILabel!
    @IBOutlet weak var summaryDetailLabel: UILabel!
    
    var breachArray = [Breach]()
    var breached : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        resignFirstResponder()

        breachArray.removeAll()
        breached = false
        
        LoadingIndicatorView.show("Checking")
        
        let account = searchBar.text!
        HaveIBeenPwnedClient.sharedInstance().getBreachesForAccount(account) {
            (breached, result, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if (error != nil) {
                    self.showError("Unable to check account. \(error!)")
                }
                else {
                    self.showResult(breached, result: result)
                }
                LoadingIndicatorView.hide()
            }
        }
    }
    
    func showResult(breached: Bool, result : AnyObject!) {
        self.breached = breached
        if (breached) {
            summaryTitleLabel.text = "Oh no — \(breachArray.count) breaches found!"
            summaryDetailLabel.text = "A \"breach\" is an incident where a site's data has been illegally accessed by hackers and then released publicly. Review the types of data that were compromised (email addresses, passwords, credit cards etc.) and take appropriate action, such as changing passwords."
            summaryView.backgroundColor = UIColor(red: 229/255, green: 000/255, blue: 0/255, alpha: 1)
            self.view.backgroundColor = UIColor(red: 229/255, green: 000/255, blue: 0/255, alpha: 1)
        }
        else {
            summaryTitleLabel.text = "Good news — no breaches found!"
            summaryDetailLabel.text = ""
            summaryView.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)
            self.view.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)
        }
        
        resultTableView.reloadData()
        resultTableView.hidden = false
        summaryView.hidden = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("Cancel")
        searchBar.resignFirstResponder()
        resignFirstResponder()
        
        resultTableView.hidden = true
        summaryView.hidden = true
    }
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breachArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier = "ResultCell"
     
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!

        return cell
    }
    
    // Show an error message with alert
    func showError(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    
}
