//
//  Alternatives.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct Alternatives: Codable {
    let confidence: Double?
    let transcript: String?
    
    enum CodingKeys: String, CodingKey {
        case confidence
        case transcript
    }
}
