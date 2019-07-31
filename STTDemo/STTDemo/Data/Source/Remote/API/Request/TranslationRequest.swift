//
//  TranslationRequest.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/30/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


import Alamofire

final class TranslationRequest: BaseRequest {
    
    required init(text: String, sourceLangCode: String, targetLangCode: String) {
        let parameters: [String: Any]  = [
            "q": text,
            "source": sourceLangCode,
            "target": targetLangCode
        ]
        
        super.init(url: Urls.baseTranslationPath, requestType: .post, parameters: parameters)
    }
}
