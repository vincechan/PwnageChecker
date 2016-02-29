//
//  BreachViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/8/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class BreachViewController: UIViewController {

    var breach : Breach!

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var compromisedDataLabel: UILabel!
    @IBOutlet weak var pwnCountLabel: UILabel!
    @IBOutlet weak var breachDateLabel: UILabel!
    @IBOutlet weak var isSensitiveSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.title = breach.title
        compromisedDataLabel.text = breach.dataClasses ?? "N/A"
        pwnCountLabel.text = breach.pwnCount?.stringValue ?? "N/A"
        breachDateLabel.text = breach.breachDate ?? "N/A"
        isSensitiveSwitch.on = breach.isSensitive?.integerValue > 0
        
        var text = ""
        if let desc = breach.desc?.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                text = try NSAttributedString(data: desc,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding],
                    documentAttributes: nil).string
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        descriptionLabel.text = text
        
        if let image = ImageCache.sharedInstance().imageWithName(breach.domain!) {
            logoImageView.image = image
        }
    }
  }
