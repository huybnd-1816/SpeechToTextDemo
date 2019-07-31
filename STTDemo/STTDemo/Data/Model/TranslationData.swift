//
//  TranslationData.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/30/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


struct TranslationData: Codable {
    let translations: [Translations]?
    
    enum CodingKeys: String, CodingKey {
        case translations
    }
}
