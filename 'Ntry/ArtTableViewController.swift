//
//  ArtViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation
import UIKit

class ArtTableViewController: UITableViewController{
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //All art pieces pulled from database
    
    //Array containing only names for table viewing
        // if client id exists, only contain art with matching cliend ID
        // otherwise, contain all art
    var clientID:String = ""
    var artData = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            //TO DO
            //Make HTTP GET request to retrieve ALL info on pieces of art
            //Parse JSON into dictionary and populate tableView
            
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
