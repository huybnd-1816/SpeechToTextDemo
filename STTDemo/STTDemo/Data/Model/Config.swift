//
//  Config.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


struct Config: Codable {
    let diarizationSpeakerCount: Int?
    let enableAutomaticPunctuation: Bool?
    let enableSpeakerDiarization: Bool?
    let encoding: String?
    let languageCode: String?
    let model: String?
    
    enum CodingKeys: String, CodingKey {
        case diarizationSpeakerCount
        case enableAutomaticPunctuation
        case enableSpeakerDiarization
        case encoding
        case languageCode
        case model
    }
}
