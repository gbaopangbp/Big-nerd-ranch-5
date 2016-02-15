//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by cm on 16/2/15.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusHeight = UIApplication.sharedApplication().statusBarFrame.height
        let inset = UIEdgeInsetsMake(statusHeight, 0, 0, 0);
        self.tableView.contentInset = inset
        self.tableView.scrollIndicatorInsets = inset
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 65
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels()

        let item = self.itemStore.allItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.valueLabel.text = "$\(item.valueInDollars)"
        cell.serialNumberLabel.text = item.serialNumber
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let item = self.itemStore.allItems[indexPath.row]
            let alert = UIAlertController(title: "Delete \(item.name)", message: "Are you sure to delte the item", preferredStyle: .ActionSheet)
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancel)
            
            let delete = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (action) in
                self.itemStore.removeItem(item)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            alert.addAction(delete)
            presentViewController(alert, animated: true, completion: nil)
            
            
           
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        itemStore.moveItem(fromIndexPath.row, toIndex: toIndexPath.row)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addItem(sender: AnyObject) {
        let item = self.itemStore.createItem()
        let row = self.itemStore.allItems.indexOf(item)
        let indexPath = NSIndexPath(forRow: row!, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
    }
    @IBAction func toggleState(sender: UIButton) {
        if editing {
            sender.setTitle("Edit", forState: .Normal)
            self.tableView.setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", forState: .Normal)
            self.tableView.setEditing(true, animated: true)
        }
    }
}
