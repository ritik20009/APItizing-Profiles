//
//  NetworkManager.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation
import UIKit

class NetworkManager {
    
    var response: SampleResponse? = SampleResponse(items: [])
    var details: UserDetail?
    
    func fetchData(apiUrl: String,initialResponse: SampleResponse?,success:@escaping (SampleResponse)->(), failure:@escaping ()->()) {
        if initialResponse == nil{
            self.response = SampleResponse()
            self.response?.items = []
        } else {
            self.response = initialResponse
        }
        
        URLSession.shared.dataTask(with: NSURL(string: apiUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "error")
                failure()
                return
            }
            let decoder = JSONDecoder()
            let object = try? decoder.decode([Item].self, from:data!)
            DispatchQueue.main.async(execute:{ () -> Void in
                self.response?.items?.append(contentsOf: object!)
                success(self.response!)
            })
        }).resume()
        
    }
    func fetchResponse(apiUrl: String,success:@escaping (UserDetail)->(), failure:@escaping ()->()) {
        
        
        URLSession.shared.dataTask(with: NSURL(string: apiUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "error")
                failure()
                return
            }
            let decoder = JSONDecoder()
            guard let object = try? decoder.decode(UserDetail.self, from:data!)
            else{
                return
            }
            //success(object)
            DispatchQueue.main.async(execute:{ () -> Void in
                success(object)
            })
        }).resume()
        
    }
    
    func fetchImage(url: String, completion: @escaping(Data) -> Void) {
        
        guard let nsUrl = NSURL(string: url) else{
            return
        }
        
        URLSession.shared.dataTask(with: nsUrl as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data)
            })
        }).resume()
    }
}

