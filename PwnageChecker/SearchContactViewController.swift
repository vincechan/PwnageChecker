//
//  SearchContactViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 3/17/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class SearchContactViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        ViewHelper.makeNavBarTransparent(navigationController)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ViewHelper.undoMakeNavBarTransparent(navigationController)
    }

}
