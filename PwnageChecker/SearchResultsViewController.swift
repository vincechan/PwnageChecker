//
//  SearchResultsViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/28/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import CoreData
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tempContext : NSManagedObjectContext!
    var account: String!
    var hasBreaches : Bool!
    var apiResult : AnyObject!
    var breaches = [Breach]()
    
    override func viewDidLoad() {
        tempContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        tempContext.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        title = account
        if (hasBreaches == true) {
            showBreach()
            
        }
        else {
            showNoBreach()
        }
    }
    
    func showBreach() {
        let breachArray = apiResult as! [[String:AnyObject]]
        for breachItem in breachArray {
            let breach = Breach(apiBreachResult: breachItem, context: tempContext)
            breaches.append(breach)
            print(breach.title)
        }
        print(breaches.count)
        
         UINavigationBar.appearance().barTintColor = UIColor(red: 229/255, green: 000/255, blue: 0/255, alpha: 1)
        
        view.backgroundColor = UIColor(red: 229/255, green: 000/255, blue: 0/255, alpha: 1)
        headerView.backgroundColor = UIColor(red: 229/255, green: 000/255, blue: 0/255, alpha: 1)
        iconLabel.text = "\u{e403}"
        titleLabel.text = "Oh no — pwned! Pwned on \(breaches.count) breached sites"
        subtitleLabel.text = "A \"breach\" is an incident where a site's data has been illegally accessed by hackers and then released publicly. Review the types of data that were compromised (email addresses, passwords, credit cards etc.) and take appropriate action, such as changing passwords."
        tableView.hidden = false
        tableView.reloadData()
    }
    
    func showNoBreach() {
        view.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)
        headerView.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1)
        iconLabel.text = "\u{e415}"
        titleLabel.text = "Good news — no pwnage found!"
        subtitleLabel.text = "No breached accounts"
        tableView.hidden = true
    }
    
    
    func configureCell(cell: BreachCell, withBreach breach: Breach) {
        cell.titleLabel.text = breach.title
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
        
        cell.descriptionLabel.text = text
        
        let dataClasses = breach.dataClasses ?? "N/A"
        let dataClassesText = NSMutableAttributedString()
        dataClassesText.appendAttributedString(NSAttributedString(string: "Compromised Data: ",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]))
        dataClassesText.appendAttributedString(NSAttributedString(string: "\(dataClasses)",
            attributes:  [NSFontAttributeName: UIFont.systemFontOfSize(12)]))
        cell.dataClassesLabel.attributedText = dataClassesText
        if let domain = breach.domain {
            cell.loadImage(domain)
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breaches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "BreachCell"
        let breach = breaches[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as! BreachCell
        configureCell(cell, withBreach: breach)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let breach = breaches[indexPath.row]
        let controller = storyboard?.instantiateViewControllerWithIdentifier("BreachViewController") as! BreachViewController
        controller.breach = breach
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
