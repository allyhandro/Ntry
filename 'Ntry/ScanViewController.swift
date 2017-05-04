//
//  ScanViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import UIKit



class ScanViewController: UIViewController{
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //Be able to update to database
    @IBOutlet weak var artLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
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
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {        
        let view2:ArtQRViewController = segue.source as! ArtQRViewController
        
        artLabel.text = view2.messageLabel.text
    }
    
    @IBAction func unwindToMenu2(segue: UIStoryboardSegue) {
        let view2:LocationQRViewController = segue.source as! LocationQRViewController
        
        locationLabel.text = view2.messageLabel.text
    }

}