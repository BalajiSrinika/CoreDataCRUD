//
//  ViewController.swift
//  CoreDataCRUD
//
//  Created by Sabari on 07/04/20.
//  Copyright © 2020 Sabari. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

       @IBOutlet weak var tableView: UITableView!
    
       var saveNamedList : [String] = []
       var BioData = [Person]()
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
          if reachability.currentReachabilityStatus == .notReachable{
             print("no network")
             self.fetchData()
          }else{
             self.getJsonFromUrl()
          }
    }
}

extension ViewController {
    
      func getJsonFromUrl(){
            
            // delete previous core data records
            deleteAllRecords()
            
            //creating a NSURL
            /// API
            let url = NSURL(string: Api)
            
            //fetching the data from the url
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
       
                  print("jsonObj=>\(String(describing: jsonObj))")
                    
                for heroe in jsonObj
                {
                  //converting the element to a dictionary
                   let heroeDict = heroe as! NSDictionary
                                
                    //getting the name from the dictionary
                    if let name = heroeDict.value(forKey: "name"),let email = heroeDict.value(forKey: "email")
                    {
                        
                        /// save data in DB
                        let context = appDelegate.persistentContainer.viewContext
                        
                        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                        let newUser = NSManagedObject(entity: entity!, insertInto: context)
                    
                        newUser.setValue((name as? String)!, forKey: "name")
                        newUser.setValue((email as? String)!, forKey: "email")

                        do {
                            try context.save()
                        } catch {
                            print("Failed saving")
                        }
                    }
                    
                }
                DispatchQueue.main.sync {
                     self.fetchData()
                     self.tableView.reloadData()
                     print("saveNamedList=>\(self.saveNamedList)")
                     print("reload page")
                }
              }
            }).resume()
         }

        func fetchData()
        {
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            //request.predicate = NSPredicate(format: "age = %@", "12")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject]
                {
                    BioData.append(Person(name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String))
                }
               } catch {
                print("Failed")
            }
        }
        
        func deleteAllRecords() {
          
            let context = appDelegate.persistentContainer.viewContext
            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
        }
        
        
        
        /// save data
        
    //    func saveData()
    //    {
    //        let context = appDelegate.persistentContainer.viewContext
    //
    //        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
    //        let newUser = NSManagedObject(entity: entity!, insertInto: context)
    //
    //        newUser.setValue("Balaji", forKey: "name")
    //        newUser.setValue("Salem", forKey: "place")
    //        newUser.setValue("1", forKey: "age")
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Failed saving")
    //        }
    //    }
}

extension ViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BioData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      print("load cell data")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "data") as? dataTableViewCell
        
        let assignDat = BioData[indexPath.row]
        cell?.labelKeyWord.text = assignDat.name
        
        return cell!
    }
}
