//
//  STTRepository.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

protocol STTRepository {
    func transcribeShortAudio(audioData: Data, languagueCode: String, completion: @escaping (BaseResult<STTResponse>) -> Void)
    func transcribeLongAudio(audioURL: String, languageCode: String, completion: @escaping (BaseResult<STTLongAudioResponse>) -> Void)
    func getAudioTransciption(nameCode: String, completion: @escaping (BaseResult<STTLongAudioResponse>) -> Void)
}

final class STTRepositoryImpl: STTRepository {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func transcribeShortAudio(audioData: Data, languagueCode: String, completion: @escaping (BaseResult<STTResponse>) -> Void) {
        let input = STTShortAudioRequest(data: audioData, languageCode: languagueCode)
        
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
    
    func transcribeLongAudio(audioURL: String, languageCode: String, completion: @escaping (BaseResult<STTLongAudioResponse>) -> Void) {
        let input = STTLongAudioRequest(uri: audioURL, languageCode: languageCode)
        
        api?.request(input: input) { (object: STTLongAudioResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getAudioTransciption(nameCode: String, completion: @escaping (BaseResult<STTLongAudioResponse>) -> Void) {
        let input = GetAudioTransciptionRequest(nameCode: nameCode)
        
        api?.request(input: input) { (object: STTLongAudioResponse?, error) in
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
