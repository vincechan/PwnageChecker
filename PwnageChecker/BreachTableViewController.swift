//
//  BreachTableViewController.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/16/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit
import CoreData

class BreachTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
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
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            HaveIBeenPwnedClient.sharedInstance().refreshBreachesInBackground() {
                (error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if (error != nil) {
                    print(error)
                    dispatch_async(dispatch_get_main_queue()) {
                        ViewHelper.showError("Unable to retrieve data from network")
                    }
                }
            }
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
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let breach = fetchedResultsController.objectAtIndexPath(indexPath) as! Breach
        let cell = tableView.dequeueReusableCellWithIdentifier(BreachCell.cellIdentifier)! as! BreachCell
        cell.configure(breach)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let breach = fetchedResultsController.objectAtIndexPath(indexPath) as! Breach
        let controller = storyboard?.instantiateViewControllerWithIdentifier("BreachViewController") as! BreachViewController
        controller.breach = breach
        navigationController?.pushViewController(controller, animated: true)
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
            cell.configure(breach)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}

