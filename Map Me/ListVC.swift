//
//  ListVC.swift
//  Map Me
//
//  Created by Scott Baumbich on 1/24/16.
//  Copyright © 2016 Scott Baumbich. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {

    let appDel = AppDelegate()
    let defaults = NSUserDefaults.standardUserDefaults()
    var parseTest = PersistParseData()
    var data: [[String:AnyObject]] = []
    
   
    
//***************************************************
// MARK: - App Life Cycle
//***************************************************

    override func viewWillAppear(animated: Bool) {
        self.view.alpha = 0
        if let storedData = (self.defaults.objectForKey("parseData")) as? [[String:AnyObject]] {
            data = storedData
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.4) {
            self.view.alpha = 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }


//***************************************************
// // MARK: - Table view data source
//***************************************************
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.imageView?.tintColor = appDel.redColor
        
        // Set List Image
        cell.imageView?.image = UIImage(named: "Pin")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let contact = data[indexPath.row]
        let contactLocation = ClientLocation(ClientLocationDict: contact)
        if let firstName = contactLocation.firstName , let lastName = contactLocation.lastName {
            cell.textLabel?.text = "\(firstName) \(lastName)"
        }
        
        // If the cell has a detail label, assign the URL.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = contactLocation.mediaURL
        }
        return cell
    }
    
    

//***************************************************
// // MARK: - Table view Delegate Methods
//***************************************************
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        let locInfo = data[indexPath.row]
        let studentInfo = ClientLocation(ClientLocationDict: locInfo)
        if let url = studentInfo.mediaURL {
            if let link = NSURL(string: url) {
                app.openURL(link)
            }
        }
    }
    
    //Display UITableView Header with specified font & color
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = appDel.grayColor
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    // Highlight selected row with specified color on touch
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = appDel.grayColor
        let highlightView = UIView()
        highlightView.backgroundColor = appDel.grayColor
        cell?.selectedBackgroundView = highlightView
    }

}
