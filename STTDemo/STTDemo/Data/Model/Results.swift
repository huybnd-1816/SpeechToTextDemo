//
//  Results.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct Results: Codable {
    let alternatives: [Alternatives]?
    
    enum CodingKeys: String, CodingKey {
        case alternatives 
    }
}
