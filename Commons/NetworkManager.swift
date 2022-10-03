//
//  NetworkManager.swift
//  iOSLearningApp
//
//  Created by Ritik Raj on 23/09/22.
//

import Foundation



class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func fetchResponse<T: Decodable>(_ api: API, completionHandler:@escaping (T?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = api.baseUrl
        components.path = api.path
        var urlQueryItems: [URLQueryItem] = []
        if let queryParams = api.QueryParams{
            queryParams.forEach{element in
                let urlQueryItem = URLQueryItem(name: element.key, value: element.value)
                urlQueryItems.append(urlQueryItem)
            }
        }
        
        components.queryItems = urlQueryItems
        
        guard let url = components.url else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        urlRequest.httpBody = nil
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "error")
                completionHandler(nil)
                return
            }
            let decoder = JSONDecoder()
            guard let object = try? decoder.decode(T.self, from:data!)
            else{
                return
            }
            DispatchQueue.main.async(execute:{ () -> Void in
                completionHandler(object)
            })
        }).resume()
    }
    
    func fetchImage(url: String, completion: @escaping(Data) -> Void) {
        guard let nsUrl = NSURL(string: url) else {
            return
        }
        URLSession.shared.dataTask(with: nsUrl as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error as Any)
                return
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data)
            })
        }).resume()
    }
}

protocol API {
    var baseUrl: String{ get }
    var path: String{ get }
    var method: HTTPMethod{ get }
    var QueryParams: [String: String]?{ get }
    var headers: [String: String]?{ get }
    var body: [String: String]?{ get }
}

extension API {
    var baseUrl: String {
        return "api.github.com"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    var headers: [String: String]?{ return nil }
    var body: [String: String]?{ return nil }
}

enum HTTPMethod: String {
    
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
    
}
