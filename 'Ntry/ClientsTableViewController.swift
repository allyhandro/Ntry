//
//  ClientViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation
import UIKit

class ClientsTableViewController: UITableViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //clien data from database
    var clientData = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    
        // Do any additional setup after loading the view, typically from a nib.
        
        //TO DO
        //Make HTTP GET request to retrieve ALL info on clients
        //Parse JSON into dictionary and populate tableView
        
        let url:String = "http://ntry.herokuapp.com/api/clients/_find"
        let urlRequest = URL(string: url)
        
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: {(data,response,error) in
            if(error != nil){
                print(error.debugDescription)
            }else{
                do{
                    self.clientData =  try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:AnyObject]]
                    OperationQueue.main.addOperation{
                        self.tableView.reloadData()
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        })
    }
    
    func fetchClients(){
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clientData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell",for:indexPath)
        let item = self.clientData[indexPath.row]
        return cell
    }
    
}
