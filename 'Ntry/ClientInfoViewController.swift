//
//  ClientInfoViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 5/4/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation


class ClientInfoTableViewController:UITableViewController{

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationItem!
    var clientName = String()
    var clientId = String()
    var client = Client()
    //Array of art listed under chosen client
    //var artData = [[String:AnyObject]]
    
    override func viewDidLoad() {
        self.navBar.title = clientName
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //SET UP CLIENT INFO
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreat
    }
    func fetchClientInfo(){
    }
}
