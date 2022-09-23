//
//  FileManager.swift
//  iOSLearningApp
//
//  Created by Ritik Rj on 14/09/22.
//

import Foundation

class FileManager {
    
    var response: SampleResponse? = SampleResponse(items: [])
    var details: UserDetail?
    //    class func loadJson(filename fileName: String) -> SampleResponse? {
    //        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
    //            do {
    //                let data = try Data(contentsOf: url)
    //
    //                let object = try JSONDecoder().decode(SampleResponse.self, from:data)
    //                return object
    //
    //            } catch {
    //                print("Error!! Unable to parse  \(fileName).json")
    //            }
    //        }
    //        return nil
    //    }
    
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
}
