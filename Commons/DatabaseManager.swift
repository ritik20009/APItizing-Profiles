//
//  DatabaseManager.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 03/10/22.
//

import Foundation

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    func saveData(Value: String, Key: String) {
        
        UserDefaults.standard.set(Value, forKey: Key)
    }
    
    func getData(Key: String) -> Bool{
        
        if UserDefaults.standard.object(forKey: Key) == nil {
            return false
        } else {
            return true
        }
    }
    
    func deletedata(Key: String) {
        
        UserDefaults.standard.removeObject(forKey: Key)
    }
    
}
