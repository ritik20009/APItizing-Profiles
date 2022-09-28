//
//  Utils.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 28/09/22.
//

import Foundation

class Utils {
    static let shared = Utils()
    private init() { }
    
    func getKeyForFavourite(userName: String)-> String {
        return "favourite\(userName)"
    }
    
}
