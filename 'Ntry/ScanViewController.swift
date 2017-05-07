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
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Parsed JSON: '\(jsonStr)'")
                } 
            }
            dataTask.resume()
            }
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {        
        let view2:ArtQRViewController = segue.source as! ArtQRViewController
        
        _ = view2.messageLabel.text
        artLabel.text = fetchTitle(ID: view2.messageLabel.text!)
        
        //TO DO OPTIONAL
        //artLabel.text = HTTP GET, replace with title of piece
    }
    
    @IBAction func unwindToMenu2(segue: UIStoryboardSegue) {
        let view2:LocationQRViewController = segue.source as! LocationQRViewController
        
        locationLabel.text = view2.messageLabel.text
    }
    
    func fetchTitle(ID: String) -> String{
        let url = NSURL(string: "https://ntry.herokuapp.com/api/items/" + ID + "/_findOne")
        URLSession.shared.dataTask(with: url! as URL){ (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let title = json["title"] as? String {
                    print(title)
                }
               // print(json)
//                for dictionary in json as! [[String: AnyObject]]{
//                    print(dictionary[""]!)
//                }
                //print(json)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        return ""
    }


}
