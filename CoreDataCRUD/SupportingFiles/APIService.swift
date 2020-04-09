//
//  APIservice.swift
//  CoreDataTutorialPart1Final
//
//  Created by James Rochabrun on 3/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    //creating a NSURL
    /// API
    lazy var endPoint: String = {
        return Api
    }()
    
    func getDataWith(completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do{
                if let response = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]{
                    DispatchQueue.main.async {
                        
                        completion(.Success(response))
                    }
                    
                }
                else{
                    completion(.Success([:]))
                }
                
            }catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





