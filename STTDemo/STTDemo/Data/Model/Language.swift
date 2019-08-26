//
//  Language.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/1/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


struct STTLanguage {
    var name: String?
    var sttCode: String?
    var sourceTransCode: String?
    var isSelected: Bool?
}

struct TranslationLanguage {
    var name: String?
    var desTransCode: String?
    var isSelected: Bool?
}

enum LanguageHelperItem {
    case Vietnam
    case Japan
    case English
    
    var nameValue : String {
        switch self {
        case .Vietnam:
            return "Vietnamese"
        case .Japan:
            return "Japanese"
        case .English:
            return "English"
        }
    }
    
    var sttCode : String {
        switch self {
        case .Vietnam:
            return "vi-VN"
        case .Japan:
            return "ja-JP"
        case .English:
            return "en-US"
        }
    }
    
    var transCode : String {
        switch self {
        case .Vietnam:
            return "vi"
        case .Japan:
            return "ja"
        case .English:
            return "en"
        }
    }
    
    var flagValue : UIImage {
        switch self {
        case .Vietnam:
            return UIImage(named: "icon_noads")!
        case .Japan:
            return UIImage(named: "icon_app_photosaver")!
        case .English:
            return UIImage(named: "icon_app_photosaver")!
        }
    }
    
    var indexValue : Int {
        switch self {
        case .Vietnam:
            return 0
        case .Japan:
            return 1
        case .English:
            return 2
        }
    }
}
