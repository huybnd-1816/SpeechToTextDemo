//
//  STTLongAudioResponse.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


struct STTLongAudioResponse: Codable {
    let name: String?
    let metadata: Metadata?
    let done: Bool?
    let response: Response?
    
    enum CodingKeys: String, CodingKey {
        case name
        case metadata
        case done
        case response
    }
}
