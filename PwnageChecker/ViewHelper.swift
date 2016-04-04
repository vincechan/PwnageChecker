//
//  ViewHelper.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/29/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class ViewHelper {
    
    static func gradientBackgroundColor() -> CAGradientLayer {
        let color1 = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        let color2 = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.CGColor, color2.CGColor]
        gradient.locations = [0.0, 1.0]
        return gradient
    }
    
    static func setGradientBackground(view: UIView) {
        let gradient = ViewHelper.gradientBackgroundColor()
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
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
