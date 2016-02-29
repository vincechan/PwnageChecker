//
//  SearchAccountViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/20/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class SearchAccountViewController: UIViewController  {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func checkButtonTouch(sender: AnyObject) {
        if searchTextField.text == nil || searchTextField.text == "" {
            showError("Please enter email address or username of your account")
            return
        }
        
        LoadingIndicatorView.show("Checking")
        
        let account = searchTextField.text!
        HaveIBeenPwnedClient.sharedInstance().getBreachesForAccount(account) {
            (hasBreaches, result, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if (error != nil) {
                    LoadingIndicatorView.hide()
                    self.showError("Unable to check account. ")
                    print(error)
                }
                else {
                    let controller =                  self.storyboard?.instantiateViewControllerWithIdentifier("SearchResultViewController") as! SearchResultsViewController
                    controller.account = account
                    controller.hasBreaches = hasBreaches
                    controller.apiResult = result
                    self.navigationController?.pushViewController(controller, animated: true)
                    LoadingIndicatorView.hide()
                }
            }
        }
    }
    
    // Show an error message with alert
    func showError(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
