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
    
    func showLoaderDecider() {
        
        let isDownloaded = DatabaseManager.shared.getData(Key: u_login)
        if !isDownloaded {
            self.delegate?.showLoaderDecider(isDownloaded: isDownloaded)
        }
    }
    
    func favouriteButtonAction() {
        
        let isFavourite = DatabaseManager.shared.getData(Key: Utils.shared.getKeyForFavourite(userName: u_login))
        if !isFavourite {
            DatabaseManager.shared.saveData(Value: "", Key: Utils.shared.getKeyForFavourite(userName: u_login))
            self.delegate?.setFavouriteStateAfterClicking(isFavourite: isFavourite)
        } else {
            UserDefaults.standard.removeObject(forKey: Utils.shared.getKeyForFavourite(userName: u_login))
            self.delegate?.setFavouriteStateAfterClicking(isFavourite: isFavourite)
        }
    }
    
    func saveButtonAction() {
        
        guard let encodedData = try? JSONEncoder().encode(details) else { return }
        guard let jsonString = String(data: encodedData, encoding: .utf8) else { return }
        
        let isDownloaded = DatabaseManager.shared.getData(Key: u_login)
        if !isDownloaded {
            DatabaseManager.shared.saveData(Value: jsonString, Key: u_login)
            self.delegate?.setDownloadedStateAfterClicking(isDownloaded: isDownloaded)
        } else {
            self.delegate?.setDeletedState(isDownloaded: isDownloaded)
        }
    }
    
    func deleteButtonAction() {
        
        DatabaseManager.shared.deletedata(Key: u_login)
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
