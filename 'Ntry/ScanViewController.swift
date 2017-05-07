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
    
    @IBAction func submit(_ sender: Any) {
        
        //My half-baked attempt at making sure a user does not submit a malformed query
        if(locationLabel.text != "" && locationLabel.text != "No QR code is detected" && artLabel.text != "" && artLabel.text != "No QR code is detected"){

            let urlString = "https://ntry.herokuapp.com/api/items/" + artLabel.text! + "/_move"
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(url: url! as URL)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
            request.httpMethod = "PUT"
            let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            let locationString = "location=" + locationLabel.text!
            let data = locationString.data(using: String.Encoding.utf8)
            request.httpBody = data
            
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
                    print("Parsed JSON: '\(jsonStr)'")
                    
                    // create the alert
                    let alert = UIAlertController(title: "Success", message: "Update successful", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                } 
            }
            dataTask.resume()
            }
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
