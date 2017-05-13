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
    
    @IBOutlet var tbView: UITableView!
    //Global Variable for name of clients
    //clientNames = [Name of Client: ID of client]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    func fetchClients(){
        let url = NSURL(string: "https://ntry.herokuapp.com/api/clients/_find")
        URLSession.shared.dataTask(with: url! as URL){ (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                ClientInfo.clients.removeAll()
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                for dictionary in json as! [[String: AnyObject]]{
                    //print(dictionary["name"]!)
                    ClientInfo.clientNames.append(dictionary["name"] as! String)
                    ClientInfo.clients.append(Client(name:dictionary["name"] as! String, id:dictionary["_id"] as! String))
                }
                ClientInfo.clientNames = ClientInfo.clientNames.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                
                
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.fetchClients()
        super.viewWillAppear(animated)
        tbView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientInfo.clientNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ClientCell",for:indexPath)
        cell.textLabel?.text = ClientInfo.clientNames[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath){
        self.performSegue(withIdentifier: "showClientInfo", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?)
    {
        if (segue.identifier == "showClientInfo")
        {
            // upcoming is set to NewViewController (.swift)
            var upcoming: ClientInfoTableViewController = segue.destination
                as! ClientInfoTableViewController
            // indexPath is set to the path that was tapped
            let indexPath = tbView.indexPathForSelectedRow!
            // titleString is set to the title at the row in the objects array.
            let client = ClientInfo.clientNames[indexPath.row]
            let clientId = ClientInfo.clients[indexPath.row].id
            // the titleStringViaSegue property of NewViewController is set.
            upcoming.clientName = client
            upcoming.clientId = clientId!
            
            self.tbView.deselectRow(at: indexPath, animated: true)
        }
    }

    
}
