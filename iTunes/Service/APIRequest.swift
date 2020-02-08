//
//  APIRequest.swift
//  iTunes
//
//  Created by Developer on 7.02.2020.
//

import Foundation
import Alamofire

class APIRequest<ReusableType:Codable> {
    var baseURL: String {
        get {
            return "https://rss.itunes.apple.com/"
        }
    }
    
    var apiPath: String {
        get {
            return "api/"
        }
    }
    
    var version: String {
        get {
            return "v1/"
        }
    }
    
    var region: String {
        return "us/"
    }
    
    var category: String {
        return "music/"
    }
    
    var feedType: String {
        return "top-free/"
    }
    
    var genre: String {
        return "all/"
    }
    
    var count: String {
        return "0/"
    }
    
    var jsonType: String {
        return "non-explicit.json"
    }
    
    var contentType: String {
        return "application/json"
    }
    
    var requestType: HTTPMethod {
        return .get 
    }
}
