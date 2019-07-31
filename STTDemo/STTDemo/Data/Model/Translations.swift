//
//  Translations.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/30/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


struct Translations: Codable {
    let translatedText: String?
    
    enum CodingKeys: String, CodingKey {
        case translatedText
    }
}
