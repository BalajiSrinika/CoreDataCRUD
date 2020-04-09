//
//  DataViewController.swift
//  CoreDataCRUD
//
//  Created by Sabari on 08/04/20.
//  Copyright © 2020 Sabari. All rights reserved.
//

import UIKit
import CoreData

enum Entity: String{
    case User = "Users"
}

enum reponseKey: String{
    case response = "response"
}

class DataViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var userList = [UserList]()

    override func viewDidLoad() {
        super.viewDidLoad()

     /// save Api  data  in DB
        createData()
        self.loadtableData()
        
        deleteProfile(entityName:.User,dataKey:reponseKey(rawValue: reponseKey.response.rawValue)!,ID:3)
    }
    
    
    /// Fetch data and load in tableView
    func loadtableData(){
        let getData = fetchData(entityName:.User,dataKey:reponseKey(rawValue: reponseKey.response.rawValue)!)!
             let responseObj = try? JSONDecoder().decode(UserData.self, from: getData)
             //print(responseObj!)
             
             userList = (responseObj?.userList)!
             print("userList:\(userList)")
             DispatchQueue.main.async {
                 self.tableView.reloadData()
             }
    }
}

extension DataViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

     return userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "data") as? dataTableViewCell
        let assignDat = userList[indexPath.row]
        cell?.labelKeyWord.text = assignDat.name

        return cell!
    }
    


    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        }

        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
            // share item at indexPath
        }

        share.backgroundColor = UIColor.blue

        return [delete, share]
    }
}

