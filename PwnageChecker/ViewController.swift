//
//  ViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/16/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        HaveIBeenPwnedClient.sharedInstance().getBreaches() {
            (result, error) in
            
            print(result)
        }
        */
        HaveIBeenPwnedClient.sharedInstance().refreshBreaches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

