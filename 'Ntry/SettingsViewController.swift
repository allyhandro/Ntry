//
//  SettingsViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation

class SettingsViewController: UIViewController{
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
