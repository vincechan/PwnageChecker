//
//  BreachCell.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/31/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class BreachCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dataClassesLabel: UILabel!
    @IBOutlet var loadImageActivityIndicator: UIActivityIndicatorView!

    
    func loadImage(companyDomain: String)->Void {
        var image = ImageCache.sharedInstance().imageWithName(companyDomain)
        
        // if image is in cache, display immediately, otherwise download and show it
        if image != nil {
            logoImageView.image = image
        }
        else {
            logoImageView.hidden = true
            loadImageActivityIndicator.hidden = false
            loadImageActivityIndicator.frame = logoImageView.frame
            loadImageActivityIndicator.startAnimating()
            
            ClearbitClient.sharedInstance().getImage(companyDomain) {
                (imageData, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    if (error != nil) {
                        print("download image error domain: \(companyDomain) error \(error)")
                    }
                    else {
                        if let image = UIImage(data: imageData!) {
                            self.logoImageView.image = image
                        }
                    }
                    self.logoImageView.hidden = false
                    self.loadImageActivityIndicator.stopAnimating()
                    self.loadImageActivityIndicator.hidden = true
                }
            }
        }
    }
}
