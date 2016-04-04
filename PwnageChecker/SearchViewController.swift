//
//  SearchViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 4/2/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit
import ContactsUI

class SearchViewController: UIViewController, CNContactPickerDelegate {
    
    override func viewDidLoad() {
        ViewHelper.setGradientBackground(view)
    }
    
    override func viewWillAppear(animated: Bool) {
        ViewHelper.makeNavBarTransparent(navigationController)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ViewHelper.undoMakeNavBarTransparent(navigationController)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func enterAccountButtonTouch(sender: AnyObject) {
        var inputTextField: UITextField?
        let prompt = UIAlertController(title: "Enter an account", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        prompt.addAction(UIAlertAction(title: "Check", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)
            if let account = inputTextField?.text {
                self.checkAccount(account)
            }
        }))
        prompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        prompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter email address or username"
            inputTextField = textField
        })
        
        presentViewController(prompt, animated: true, completion: nil)
    }
    
    
    @IBAction func selectContactButtonTouch(sender: AnyObject) {
        // show contact picker and configure it with the following behaviors:
        // contacts with 0  email address:   disabled, cannot be selected.
        // contacts with 1  email address:   when selected, the contact's only email address will be used
        // contacts with 1+ email addresses: when selected, the detail of the contact will be presented, and user can select one of the email addresses
        
        let contactPickerViewController = CNContactPickerViewController()
        
        // disable contacts with no email addresses
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        
        // when a contact is selected, show contact detail if there are more than 1 email addresses
        contactPickerViewController.predicateForSelectionOfContact = NSPredicate(format: "emailAddresses.@count == 1")
        
        // in contact detail card, only show the email address
        contactPickerViewController.displayedPropertyKeys = [CNContactEmailAddressesKey]
        
        contactPickerViewController.delegate = self
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    func checkAccount(account: String) {
        HaveIBeenPwnedClient.sharedInstance().getBreachesForAccount(account) {
            (hasBreaches, result, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if (error != nil) {
                    LoadingIndicatorView.hide()
                    ViewHelper.showError("Unable to check account. ")
                    print(error)
                }
                else {
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SearchResultViewController") as! SearchResultsViewController
                    controller.account = account
                    controller.hasBreaches = hasBreaches
                    controller.apiResult = result
                    self.navigationController?.pushViewController(controller, animated: true)
                    LoadingIndicatorView.hide()
                }
            }
        }
    }
    
    // MARK: CNContactPickerDelegate function
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        let account = contact.emailAddresses[0].value as! String
        checkAccount(account)
        
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        let account = contactProperty.value as! String
        checkAccount(account)
    }
}
