//
//  Response.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct Response: Codable {
    let type: String?
    let results: [Results]?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case results
    }
}
