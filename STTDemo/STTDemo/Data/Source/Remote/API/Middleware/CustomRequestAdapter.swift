//
//  CustomRequestAdapter.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

final class CustomRequestAdapter: RequestAdapter {
    private var headers = Alamofire.SessionManager.defaultHTTPHeaders
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
//        urlRequest.setValue(APIKey.apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
        urlRequest.setValue(Bundle.main.bundleIdentifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
