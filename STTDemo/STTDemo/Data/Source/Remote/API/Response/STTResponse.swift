//
//  STTResponse.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct STTResponse: Codable {
    let results: [Results]?

    enum CodingKeys: String, CodingKey {
        case results
    }
}
