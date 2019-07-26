//
//  GetAudioTransciptionRequest.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

final class GetAudioTransciptionRequest: BaseRequest {
    
    required init(nameCode: String) {
        super.init(url: Urls.basePath + UrlTypes.getAudioTransciption + nameCode, requestType: .get)
    }
}
