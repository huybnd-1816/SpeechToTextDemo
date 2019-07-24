//
//  BaseRequest.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

typealias JSONDictionary = [String: Any]

class BaseRequest {
    var url = ""
    var requestType = Alamofire.HTTPMethod.get
    var parameters: [String: Any]?
    
    init(url: String) {
        self.url = url
    }
    
    init(url: String, requestType: Alamofire.HTTPMethod) {
        self.url = url
        self.requestType = requestType
    }
    
    init(url: String, requestType: Alamofire.HTTPMethod, parameters: [String: Any]?) {
        self.url = url
        self.requestType = requestType
        self.parameters = parameters
    }
    
    var encoding: ParameterEncoding {
        switch requestType {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
