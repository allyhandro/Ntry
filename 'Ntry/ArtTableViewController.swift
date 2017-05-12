//
//  ArtViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation
import UIKit

class ArtTableViewController: UITableViewController{
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    

    @IBOutlet var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            //TO DO
            //Make HTTP GET request to retrieve ALL info on pieces of art
            //Parse JSON into dictionary and populate tableView
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //change to fetch art
    
    func fetchArt(){
        let url = NSURL(string: "https://ntry.herokuapp.com/api/items/_find")
        URLSession.shared.dataTask(with: url! as URL){ (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                ArtInfo.artTitles.removeAll()
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                for dictionary in json as! [[String: AnyObject]]{
                    //print(dictionary["name"]!)
                    ArtInfo.artTitles.append(dictionary["title"] as! String)
                    ArtInfo.pieces.append( Art(title:(dictionary["title"] as! String), id:(dictionary["_id"] as? String)))
                }
                //print(ArtInfo.pieces);
                
                ArtInfo.artTitles = ArtInfo.artTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.fetchClients()
        super.viewWillAppear(animated)
        tbView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.fetchArt()
        return ArtInfo.artTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ArtCell",for:indexPath)
        //print(indexPath.row)
        cell.textLabel?.text = ArtInfo.artTitles[indexPath.row]
        return cell
    }
    
}

