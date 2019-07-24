//
//  STTRequest.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct STTRequest: Codable {
    let audio: Audio?
    let config: Config?
    
    enum CodingKeys: String, CodingKey {
        case audio
        case config
    }
}
