//
//  HomePageViewModel.swift
//  iOSLearningApp
//
//  Created by Ritik Rj on 25/09/22.
//

import Foundation
import UIKit
class HomePageViewModel {
    var response: SampleResponse? = SampleResponse(items: [])
    var delegate:ViewControllerProtocol?
    var pagenumber = 1
    func fetchData() -> () {
        let network = NetworkManager()
        
        network.fetchResponse(PullRequestApi(pageNumber: self.pagenumber), completionHandler: {(data:[Item]?) in
            guard let data = data else {
                return
            }
            self.response?.items?.append(contentsOf: data)
            self.delegate?.dataLoaded()
            self.delegate?.hideLoader()
            self.pagenumber += 1
        })
    }
    
    func showNext(indexPath:IndexPath, tableSize:Int){
        if(indexPath.row == tableSize - 2){
            self.fetchData()
        }
    }
}

struct PullRequestApi: API {
    
    var pageNumber: Int
    let pageSize: Int = 10
    var path: String{
        return "/repos/apple/swift/pulls"
    }
    
    var QueryParams: [String : String]?{
        return ["page":"\(pageNumber)", "per_page":"\(pageSize)"]
    }
    
    var headers: [String : String]?
    
    var body: [String : String]?
}
