//
//  UserTableViewController.swift
//  InstagramClone
//
//  Created by Piktochart-Edsil on 11/5/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [""]
    var userids = [""]
    var isFollowing = [false]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()?.addAscendingOrder("username")
        
        query?.findObjectsInBackgroundWithBlock({ (userObjects, error) -> Void in
            if let users = userObjects {
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                
                for userObject in users {
                    if let user = userObject as? PFUser {
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.usernames.append(user.username!)
                            self.userids.append(user.objectId!)
                            
                            var query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                if let objects = objects {
                                    if objects.count == 0 {
                                        self.isFollowing.append(true)
                                    } else {
                                        self.isFollowing.append(false)
                                    }
                                }
                                
                                if self.isFollowing.count == self.usernames.count {
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                }
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        
        if isFollowing[indexPath.row] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        var following = PFObject(className: "followers")
        following["following"] = userids[indexPath.row]
        following["follower"] = PFUser.currentUser()?.objectId
        
        following.saveInBackground()
    }
}
