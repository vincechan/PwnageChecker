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
    
    override func viewWillAppear(animated: Bool) {
        ViewHelper.makeNavBarTransparent(navigationController)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ViewHelper.undoMakeNavBarTransparent(navigationController)
    }
    
    @IBAction func checkButtonTouch(sender: AnyObject) {
        if searchTextField.text == nil || searchTextField.text == "" {
            ViewHelper.showError("Please enter email address or username of your account")
            return
        }
        
        LoadingIndicatorView.show("Checking")
        
        let account = searchTextField.text!
        HaveIBeenPwnedClient.sharedInstance().getBreachesForAccount(account) {
            (hasBreaches, result, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if (error != nil) {
                    LoadingIndicatorView.hide()
                    ViewHelper.showError("Unable to check account. ")
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
}
