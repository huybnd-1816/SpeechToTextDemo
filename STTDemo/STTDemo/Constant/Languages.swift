//
//  Constant.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


enum STTLanguages {
    case Japanese, Vietnamese, English
    
    var languageCode: String {
        switch self {
        case .Japanese:
            return "ja-JP"
        case .Vietnamese:
            return "vi-VN"
        case .English:
            return "en-US"
        }
    }
}

enum TranslationLanguages {
    case Japanese, Vietnamese, English
    
    var languageCode: String {
        switch self {
        case .Japanese:
            return "ja"
        case .Vietnamese:
            return "vi"
        case .English:
            return "en"
        }
    }
}
