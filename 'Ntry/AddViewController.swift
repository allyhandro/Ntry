//
//  AddViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation

class AddViewController: UIViewController{
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var artImage: UIImageView!
    
    @IBOutlet weak var artLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    
    @IBOutlet weak var entryLabel: UILabel!
    
    @IBOutlet weak var locLabel: UILabel!
    
    @IBOutlet weak var accessLabel: UILabel!
    
    @IBOutlet weak var accessButton: UIButton!
    
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
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
