//
//  UserDetailsViewModel.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 26/09/22.
//

import Foundation

final class UserDetailsViewModel {
    
    var details: UserDetail?
    var delegate:userDetailViewControllerProtocol?
    
    var u_login: String = ""
    func fetchData () -> () {
        var isFavourite = true
        if UserDefaults.standard.object(forKey: Utils.shared.getKeyForFavourite(userName: u_login)) == nil {
            isFavourite = false
        }
        self.delegate?.setFavouriteState(isFavourite: isFavourite)
        var isDownloaded = true
        if UserDefaults.standard.object(forKey: u_login) == nil {
            isDownloaded=false
        }
        self.delegate?.setDownloadState(isDownloaded: isDownloaded)
        NetworkManager.shared.fetchResponse(userDetailsApi(u_login: u_login), completionHandler: {(data:UserDetail?) in
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
