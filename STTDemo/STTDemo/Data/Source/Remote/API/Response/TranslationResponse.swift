//
//  TranslationResponse.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/30/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct TranslationResponse: Codable {
    let translationData: TranslationData?
    
    enum CodingKeys: String, CodingKey {
        case translationData = "data"
    }
}
