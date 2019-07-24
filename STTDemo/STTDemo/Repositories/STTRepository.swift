//
//  STTRepository.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

protocol STTRepository {
    func transcribeAudio(audioData: Data, languagueCode: String, completion: @escaping (BaseResult<STTResponse>) -> Void)
}

final class STTRepositoryImpl: STTRepository {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func transcribeAudio(audioData: Data, languagueCode: String, completion: @escaping (BaseResult<STTResponse>) -> Void) {
        let input = SpeechToTextRequest(data: audioData, languageCode: languagueCode)
        
        api?.request(input: input) { (object: STTResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
