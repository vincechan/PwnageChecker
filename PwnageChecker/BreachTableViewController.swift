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
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if (fetchedResultsController.fetchedObjects?.count == 0) {
            HaveIBeenPwnedClient.sharedInstance().refreshBreaches()
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Breach")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pwnCount", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    func configureCell(cell: UITableViewCell, withBreach breach: Breach) {
        cell.textLabel!.text = breach.title
        cell.detailTextLabel?.text = "\(breach.pwnCount!) Accounts"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = "BreachCell"
        let breach = fetchedResultsController.objectAtIndexPath(indexPath) as! Breach
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as UITableViewCell
        configureCell(cell, withBreach: breach)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let breach = fetchedResultsController.objectAtIndexPath(indexPath)
        print("\(breach.title!)")
        /*
    // present the detail view when a meme is selected
    let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
    controller.memeIndex = indexPath.row
    navigationController!.pushViewController(controller, animated: true)
        */
    }
    
    
    
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
            let cell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
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

