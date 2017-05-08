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
    
            //I. GET the status using artLabel.text
            let urlString = "https://ntry.herokuapp.com/api/items/" + artLabel.text! + "/_move"
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(url: url! as URL)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
            request.httpMethod = "GET"
        
            let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        
            //"GET" and store "status" from the database based on the "artLabel.text & changeStatus to opposite of "status"
            //request to get the status of item
            var status:String!
            
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
                
                    do{
                        //retrieve the status
                        let jsonStr = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:String]
                        status = jsonStr?["status"] as? String!
                        print ("The status of " + self.artLabel.text! + "is: " + status)

                        print("Parsed JSON: '\(jsonStr)'")
                        
                        
                        //II.Changing the status
                        var changeStatus:String!
                        if(status.isEqual("in")){
                            changeStatus = "status=off"
                        }
                        if(status.isEqual("out")){
                            changeStatus = "status=on"
                        }else{
                            let alerted = UIAlertController(title: "Uh-oh!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                            
                            // add an action (button)
                            alerted.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            // show the alert
                            self.present(alerted, animated: true, completion: nil)
                            
                        }
                        
                        //Attempt to change the database
                        let changeRequest = NSMutableURLRequest(url: url! as URL)
                        changeRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
                        changeRequest.httpMethod = "PUT"
                        let changeSession = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                        
                        let changeData = changeStatus.data(using: String.Encoding.utf8)
                        changeRequest.httpBody = changeData
                        let changeDataTask = changeSession.dataTask(with: changeRequest as URLRequest) { (changeData, changeResponse, error) -> Void in
                            if error != nil {
                                print(error!)
                                
                                // create the alert
                                let alerter = UIAlertController(title: "Uh-oh!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add an action (button)
                                alerter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                
                                // show the alert
                                self.present(alerter, animated: true, completion: nil)
                            }
                            else {
                                let jsonStr = NSString(data: changeData!, encoding: String.Encoding.utf8.rawValue)
                                print("Parsed JSON: '\(jsonStr)'")
                                
                                // create the alert
                                let alert = UIAlertController(title: "Success", message: "Update successful", preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        changeDataTask.resume()
                        
                        
                        // create the alert
                        let alert = UIAlertController(title: "Success", message: "Update successful", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                        
                    }catch{
                        let alertt = UIAlertController(title: "Uh-oh!", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alertt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alertt, animated: true, completion: nil)

                    }
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
