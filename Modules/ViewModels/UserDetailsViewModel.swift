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
        
        let network = NetworkManager()
        network.fetchResponse(userDetailsApi(u_login: u_login), completionHandler: {(data:UserDetail?) in
            guard let data = data else {
                return
            }
            self.details = data
            self.delegate?.dataLoaded()
            self.delegate?.hideLoader()
        })
    }
}

struct userDetailsApi: API{
    
    var u_login: String = ""
    var path: String{
        return "/users/\(u_login)"
    }
    
    var QueryParams: [String : String]?{
        return nil
    }
}
