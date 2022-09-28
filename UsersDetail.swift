////
////  UsersDetail.swift
////  iOSLearningApp
////
////  Created by Ritik Raj on 20/09/22.
////
//
//import Foundation
//
//

struct UserDetail: Encodable, Decodable{
    var login: String?
    var name: String?
    var company: String?
    var location: String?
    var public_repos: Int?
    var followers: Int?
    var following: Int?
    var avatar_url: String?
}
