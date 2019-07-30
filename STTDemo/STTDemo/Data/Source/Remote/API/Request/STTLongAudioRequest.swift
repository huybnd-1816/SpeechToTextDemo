//
//  STTLongAudioRequest.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

final class STTLongAudioRequest: BaseRequest {
    
    required init(uri: String, languageCode: String) {
        let config: [String: Any] = ["encoding": "LINEAR16",
                                     "languageCode": languageCode,
                                     "enableAutomaticPunctuation": true,
                                     "maxAlternatives": 30,
                                     "sampleRateHertz": 16000,
                                     "enableWordTimeOffsets": false,
                                     "audioChannelCount": 2,
                                     "profanityFilter": true,
                                     "enableSeparateRecognitionPerChannel": true,
                                     "model": "default"]
        let audio = ["uri": uri]
        let parameters: [String: Any]  = [
            "audio": audio,
            "config": config
        ]
        
        super.init(url: Urls.basePath + UrlTypes.longRunningRecognize + "?key=\(APIKey.apiKey)", requestType: .post, parameters: parameters)
    }
}
