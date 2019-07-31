//
//  TranslationRepository.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/30/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


protocol TranslationRepository {
    func translateText(text: String, sourceLangCode: String, targetLangCode: String, completion: @escaping (BaseResult<TranslationResponse>) -> Void)
}

final class TranslationRepositoryImpl: TranslationRepository {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func translateText(text: String, sourceLangCode: String, targetLangCode: String, completion: @escaping (BaseResult<TranslationResponse>) -> Void) {
        let input = TranslationRequest(text: text, sourceLangCode: sourceLangCode, targetLangCode: targetLangCode)
        
        api?.request(input: input) { (object: TranslationResponse?, error) in
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
