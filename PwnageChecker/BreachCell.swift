//
//  BreachCell.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/31/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

class BreachCell: UITableViewCell {
    
     static var cellIdentifier = "BreachCell"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dataClassesLabel: UILabel!
    @IBOutlet var loadImageActivityIndicator: UIActivityIndicatorView!
    
    func configure(breach: Breach) {
        titleLabel.text = breach.title
        
        if let descriptionText = breach.desc?.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                descriptionLabel.text = try NSAttributedString(data: descriptionText,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                        NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding],
                    documentAttributes: nil).string
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        let dataClasses = breach.dataClasses ?? "N/A"
        let dataClassesText = NSMutableAttributedString()
        dataClassesText.appendAttributedString(NSAttributedString(string: "Compromised Data: ",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]))
        dataClassesText.appendAttributedString(NSAttributedString(string: "\(dataClasses)",
            attributes:  [NSFontAttributeName: UIFont.systemFontOfSize(12)]))
        dataClassesLabel.attributedText = dataClassesText
        
        if let domain = breach.domain {
            loadImage(domain)
        }
        
        accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    private func loadImage(companyDomain: String)->Void {
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
