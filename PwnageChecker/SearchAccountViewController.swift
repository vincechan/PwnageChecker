//
//  SearchAccountViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/20/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class SearchAccountViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        ViewHelper.makeNavBarTransparent(navigationController)
        
        // subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        ViewHelper.undoMakeNavBarTransparent(navigationController)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func checkButtonTouch(sender: AnyObject) {
        if searchTextField.isFirstResponder() {
            searchTextField.resignFirstResponder()
        }
        
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
    
    
    // dismiss keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkButtonTouch(self)
        return false
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // shift view up when keyboard for text field is showing
    func keyboardWillShow(notification: NSNotification) {
        //view.frame.origin.y = -getKeyboardHeight(notification)
        let newSize = CGSize(width: view.frame.width, height: view.frame.height - getKeyboardHeight(notification))
        view.frame = CGRect(origin: view.frame.origin, size: newSize)
    }
    
    // shift view back down when keyboard for text field is hiding
    func keyboardWillHide(notification: NSNotification) {
        //view.frame.origin.y =  CGFloat(0)
        let newSize = CGSize(width: view.frame.width, height: view.frame.height + getKeyboardHeight(notification))
        view.frame = CGRect(origin: view.frame.origin, size: newSize)
    }
    
    // determine the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
}
