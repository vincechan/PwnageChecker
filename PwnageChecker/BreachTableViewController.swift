//
//  BreachTableViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/16/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit
import CoreData

class BreachTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if (fetchedResultsController.fetchedObjects?.count == 0) {
            HaveIBeenPwnedClient.sharedInstance().refreshBreachesInBackground()
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Breach")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
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
        // Initialize with a string and inline attribute(s)
        dataClassesText.appendAttributedString(NSAttributedString(string: "Compromised Data: ",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]))
        dataClassesText.appendAttributedString(NSAttributedString(string: "\(dataClasses)",
            attributes:  [NSFontAttributeName: UIFont.systemFontOfSize(12)]))
        cell.dataClassesLabel.attributedText = dataClassesText
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = "BreachCell"
        let breach = fetchedResultsController.objectAtIndexPath(indexPath) as! Breach
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as! BreachCell
        configureCell(cell, withBreach: breach)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let breach = fetchedResultsController.objectAtIndexPath(indexPath)
        print("\(breach.title!)")
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            let breach = controller.objectAtIndexPath(indexPath!) as! Breach
            let cell = tableView.cellForRowAtIndexPath(indexPath!)! as! BreachCell
            configureCell(cell, withBreach: breach)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}

