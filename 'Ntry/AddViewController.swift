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

    //Information pulled from database based on art selected from art page
    
    @IBOutlet weak var artLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    
    @IBOutlet weak var entryLabel: UILabel!
    
    @IBOutlet weak var packingLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
