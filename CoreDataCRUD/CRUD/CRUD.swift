//
//  CRUD.swift
//  CoreDataCRUD
//
//  Created by Sabari on 08/04/20.
//  Copyright © 2020 Sabari. All rights reserved.
//

import Foundation
import CoreData
import UIKit

func createData() {
        
     let service = APIService()
     service.getDataWith { (result) in
        
         switch result {
         case .Success(let data):
               // delete previous core data records
            deleteAllRecords()
            SaveData(entityName:.User, ApiDataKey: data)
           
         case .Error(let message):
             DispatchQueue.main.async {
                 showAlertWith(title: "Error", message: message)
             }
           }
         }
      }
    
    func SaveData(entityName:Entity,ApiDataKey:Any){
        /// save data in DB
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(ApiDataKey, forKey: reponseKey.response.rawValue)
        
        do {
            try context.save()
            DispatchQueue.main.async {
                let obj = fetchData(entityName:.User, dataKey: .response)
                print("obj:\(String(describing: obj))")
            }
        } catch {
            print("Failed saving")
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
          
          let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
          let action = UIAlertAction(title: title, style: .default) { (action) in
            //self.dismiss(animated: true, completion: nil)
          }
          alertController.addAction(action)
          DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
         // self.present(alertController, animated: true, completion: nil)
      }


    func fetchData(entityName:Entity,dataKey:reponseKey)-> Data?{
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        
        do {
            let result = try context.fetch(request)
            if result.count > 0{
                //Send Data
                let obj = result[0] as! NSManagedObject
                let responseData = obj.value(forKey:dataKey.rawValue)
                let dataObj = try? JSONSerialization.data(withJSONObject:responseData ?? nil!)
//                let responseObj = try? JSONDecoder().decode(UserData.self, from: dataObj!)
//                print(responseObj)
                return dataObj
            }
            else{
                //There is no data in this entity
                //Return Nil
                return nil
            }
        } catch {
            print("Failed")
            return nil
        }
    }

  
    func updateAll(entityName:Entity,data:Any){
        //Get Data using Entity name
        //If Data exist, Replace data
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


//  func deleteProfile(entityName:Entity,dataKey:reponseKey,ID:Int) {
//              let context = appDelegate.persistentContainer.viewContext
//
//              let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
//
//              do {
//                  let result = try context.fetch(request)
//                  if result.count > 0{
//                      //Send Data
//                      let obj = result[0] as! NSManagedObject
//                      let responseData = obj.value(forKey:dataKey.rawValue) as? [String: AnyObject]
//                      let userList = responseData!["user_list"]
//
//                      let dataObj = try? JSONSerialization.data(withJSONObject:responseData ?? nil!)
//                      // let responseObj = try? JSONDecoder().decode(UserData.self, from: dataObj!)
//                      // print(responseObj)
//
////                    for index in 0...(userList?.count)! - 1{
////                        context.delete(responseData![index] as NSManagedObject)
////                    }
//
//                  }
//                  else{
//                      //There is no data in this entity
//                      //Return Nil
//                  }
//              } catch {
//                  print("Failed")
//
//              }
//  }
