//
//  Metadata.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct Metadata: Codable {
    let type: String?
    let progressPercent: Int?
    let startTime: String?
    let lastUpdateTime: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case progressPercent
        case startTime
        case lastUpdateTime
    }
}
