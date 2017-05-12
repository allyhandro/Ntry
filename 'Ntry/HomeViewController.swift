//
//  HomeController.swift
//  'Ntry
//
//  Created by Caroline Lai on 4/18/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation
import UIKit

struct Client{
    var name: String!
    //other info about client
}
struct Art{
    var title: String!
    var id: String!
}

struct ClientInfo{
    static var clientNames = [String]()
    static var clients = [Client]()
}
struct ArtInfo{
    static var artTitles = [String]()
    static var pieces = [Art]()
}

class HomeViewController: UIViewController{

    @IBOutlet weak var menuButton: UIBarButtonItem!

    //size of array from database
    @IBOutlet weak var clienNum: UILabel!
    @IBOutlet weak var artNum: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchClients()
        self.fetchArt()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    ClientInfo.clients.append(Client(name:dictionary["name"] as! String))
                }
                ClientInfo.clientNames = ClientInfo.clientNames.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

                
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }

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


    
    
}
