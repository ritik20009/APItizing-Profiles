//
//  SampleResponse.swift
//  iOSLearningApp
//
//  Created by Ritik Rj on 14/09/22.
//

import Foundation

struct SampleResponse: Decodable {
    var items: [Item]?
}

struct Item: Decodable{
    var id: Double?
    var title: String?
    var user: User?
    var body: String?
}

struct User: Decodable{
    var id: Double?
    var type: String?
    var login: String?
    var avatar_url: String?
}
