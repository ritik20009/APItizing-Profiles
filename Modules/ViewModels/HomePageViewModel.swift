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
    var pageNumber = 1
    func fetchData() -> () {
//        let success: (_ res:SampleResponse) -> ()  = {(res)-> Void in
//            self.response = res
//            self.delegate?.dataLoaded()
//            self.delegate?.hideLoader()
//        }
//        let showError: () -> ()  = {()-> Void in
//            print("Inside error handler")
//        }
        let network = NetworkManager()
        let homeUrl = "https://api.github.com/repos/apple/swift/pulls?page=\(self.pageNumber)&per_page=10"
        //network.fetchData(apiUrl: homeurl,initialResponse: response, success: success, failure: showError)
        
        network.fetchResponse(url: homeUrl, completionHandler: {(data:[Item]?) in
            guard let data = data else {
                return
            }
            self.response?.items?.append(contentsOf: data)
            self.delegate?.dataLoaded()
            self.delegate?.hideLoader()
        })
        pageNumber+=1
    }
}
