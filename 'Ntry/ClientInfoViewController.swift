//
//  ClientInfoViewController.swift
//  'Ntry
//
//  Created by Caroline Lai on 5/4/17.
//  Copyright © 2017 Caroline Lai. All rights reserved.
//

import Foundation


class ClientInfoTableViewController:UITableViewController{

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var tbView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    var clientName = String()
    var clientId = String()
    var client = Client()
    //Array of art listed under chosen client
    //var artData = [[String:AnyObject]]
    
    override func viewDidLoad() {
        self.navBar.title = clientName
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 165
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //SET UP CLIENT INFO
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchClientItems(){
        let url = NSURL(string: "https://ntry.herokuapp.com/api/clients/" + clientId + "/_findItems")
        URLSession.shared.dataTask(with: url! as URL){ (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                ArtInfo.pieces.removeAll()
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                for dictionary in json as! [[String: AnyObject]]{
                    print(dictionary["title"]!)
                    ArtInfo.artTitles.append(dictionary["title"] as! String)
                }
                ArtInfo.artTitles = ArtInfo.artTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        //self.fetchClients()
        super.viewWillAppear(animated)
        tbView.reloadData()
    }
 */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArtInfo.artTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ArtCell",for:indexPath)
        cell.textLabel?.text = ArtInfo.artTitles[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath){
        self.performSegue(withIdentifier: "showItemInfo", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreat
    }

}
