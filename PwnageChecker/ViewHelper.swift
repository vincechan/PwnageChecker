//
//  ViewHelper.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/29/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class ViewHelper {
    
    static func showError(error: String) {
        guard let currentMainWindow = UIApplication.sharedApplication().keyWindow else {
            print("No main window.")
            return
        }
        let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        currentMainWindow.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func makeNavBarTransparent(navigationController : UINavigationController?) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.view.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    static func undoMakeNavBarTransparent(navigationController: UINavigationController?) {
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
}
