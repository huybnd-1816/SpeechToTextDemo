//
//  SpeechToTextRequest.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

final class SpeechToTextRequest: BaseRequest {
    
    required init(data: Data, languageCode: String) {
        let config: [String: Any] = ["encoding": "LINEAR16",
                                     "languageCode": languageCode,
                                     "enableSpeakerDiarization": true,
                                     "enableAutomaticPunctuation": true,
                                     "maxAlternatives": 30,
                                     "sampleRateHertz": 16000,
                                     "enableWordTimeOffsets": false,
                                     "audioChannelCount": 2,
                                     "enableSeparateRecognitionPerChannel": true,
                                     "model": "default"]
        let audio = ["content": data.base64EncodedString()]
        let parameters: [String: Any]  = [
            "audio": audio,
            "config": config
        ]
        
        super.init(url: Urls.basePath + UrlTypes.recognize + "?key=\(APIKey.apiKey)", requestType: .post, parameters: parameters)
    }
}
