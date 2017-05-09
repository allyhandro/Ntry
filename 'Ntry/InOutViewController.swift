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
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
    
    
    //When "submit" is pressed,
    

    @IBAction func submit(_ sender: Any) {
        
        //My half-baked attempt at making sure a user does not submit a malformed query
        if(artLabel.text != "" && artLabel.text != "No QR code is detected"){
    
            //Prepare the url and request
            let urlString = "https://ntry.herokuapp.com/api/items/" + artLabel.text! + "/_check_in_out"
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(url: url! as URL)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
            request.httpMethod = "PUT"
        
            let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            
            //Make the request to change the status
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                
                if error != nil {
                    print(error!)
                    
                    // create the alert
                    let alert = UIAlertController(title: "Uh-oh!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    var statusStr:String!
                    if(jsonStr?.range(of: "out") != nil){
                        statusStr = "Status: Out";
                    }
                        else{
                        statusStr = "Status: In";
                    }
                    let alert = UIAlertController(title: "Status Changed!", message: statusStr as String?, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                    //self.statusLabel.text = stringResponse
                }
            }
            dataTask.resume()
        
        }
    }
    
    @IBAction func unwindToInOut(segue: UIStoryboardSegue) {
        let view2:InOutQRViewController = segue.source as! InOutQRViewController
        
        artLabel.text = view2.messageLabel.text
        
    }
}
