//
//  InOutViewController.swift
//  'Ntry
//
//  Created by Ally Han on 5/7/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation
import UIKit

class InOutViewController: UIViewController{

    @IBOutlet weak var artLabel: UILabel!
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        let view2:ArtQR2ViewController = segue.source as! ArtQRViewController
        
        artLabel.text = view2.messageLabel.text
        
    }
}
