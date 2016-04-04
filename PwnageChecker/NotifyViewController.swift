//
//  NotifyViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 4/4/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class NotifyViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://haveibeenpwned.com/NotifyMe")!))

        self.navigationController?.navigationBarHidden = true
    }
}
