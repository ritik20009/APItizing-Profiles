//
//  UserDetailsViewModel.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 26/09/22.
//

import Foundation

class UserDetailsViewModel {
    
    var details: UserDetail?
    var delegate:userDetailViewControllerProtocol?
    
    var u_login: String = ""
    func fetchData () -> () {
        
//        let success: (_ res:UserDetail) -> ()  = {(res)-> Void in
//            self.details = res
//            self.delegate?.dataLoaded()
//            self.delegate?.hideLoader()
//        }
//        let showError: () -> ()  = {()-> Void in
//            print("Inside error handler")
//        }
        let network = NetworkManager()
        var loginUrl = "https://api.github.com/users/"
        loginUrl = loginUrl+(self.u_login)
        network.fetchResponse(url: loginUrl, completionHandler: {(data:UserDetail?) in
            guard let data = data else {
                return
            }
            self.details = data
            self.delegate?.dataLoaded()
            self.delegate?.hideLoader()
        })
    }
}
