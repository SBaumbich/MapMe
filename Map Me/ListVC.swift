//
//  ListVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/24/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {

    override func viewWillAppear(animated: Bool) {
        self.view.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.4) {
            self.view.alpha = 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
//        let contact = contactsArray[indexPath.row]
//        cell.textLabel!.text = contact.name
//        cell.imageView?.image = UIImage(data: contact.smallImageData!)
//        
//        // If the cell has a detail label, assign the phoneNumber.
//        if let detailTextLabel = cell.detailTextLabel {
//            if let workPhone = contact.phone!["work"] as? String {
//                detailTextLabel.text = workPhone
//            }
//        }
        return cell
    }


    
    
    // MARK: - Delegate Methods
    let grayColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1.0)
    
    //Display UITableView Header with specified font & color
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = grayColor
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    // Highlight selected row with specified color on touch
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = grayColor
        let highlightView = UIView()
        highlightView.backgroundColor = grayColor
        cell?.selectedBackgroundView = highlightView
    }

}
