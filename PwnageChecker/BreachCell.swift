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
        let image = ImageCache.sharedInstance().imageWithName(companyDomain)
        
        // if image is in cache, display immediately, otherwise download and show it
        if image != nil {
            logoImageView.image = image
        }
        else {
            logoImageView.hidden = true
            loadImageActivityIndicator.frame = logoImageView.frame
            loadImageActivityIndicator.startAnimating()
            
            ClearbitClient.sharedInstance().getImage(companyDomain) {
                (imageData, error) in
                var downloadImage = UIImage(named: "noImage")
                if (error != nil) {
                    print("download image error domain: \(companyDomain) error \(error)")
                }
                else {
                    if let image = UIImage(data: imageData!) {
                        downloadImage = image
                        ImageCache.sharedInstance().storeImage(image, withName: companyDomain)
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.logoImageView.image = downloadImage
                    self.logoImageView.hidden = false
                    self.loadImageActivityIndicator.stopAnimating()
                }
            }
        }
    }
}
