//
//  ForeignLanguages.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/5/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class ForeignLanguages {
    static let shared = ForeignLanguages()
    
    var listLanguages: [STTLanguage] = []
    var translatingLanguages: [TranslationLanguage] = []
    
    private init() {
        // STT Language
        let japaneseSTT = STTLanguage(name: "Japanese", sttCode: STTLanguages.Japanese.languageCode, sourceTransCode: TranslationLanguages.Japanese.languageCode, isSelected: true)
        let englishSTT = STTLanguage(name: "English", sttCode: STTLanguages.English.languageCode, sourceTransCode: TranslationLanguages.English.languageCode, isSelected: false)
        let vietnameseSTT = STTLanguage(name: "Vietnamese", sttCode: STTLanguages.Vietnamese.languageCode, sourceTransCode: TranslationLanguages.Vietnamese.languageCode, isSelected: false)
        listLanguages.append(contentsOf: [japaneseSTT, englishSTT, vietnameseSTT])
        
        // Translation Language
        let japaneseTrans = TranslationLanguage(name: "Japanese", desTransCode: TranslationLanguages.Japanese.languageCode, isSelected: false)
        let englishTrans = TranslationLanguage(name: "English", desTransCode: TranslationLanguages.English.languageCode, isSelected: false)
        let vietnameseTrans = TranslationLanguage(name: "Vietnamese", desTransCode: TranslationLanguages.Vietnamese.languageCode, isSelected: true)
        
        translatingLanguages.append(contentsOf: [japaneseTrans, englishTrans, vietnameseTrans])
    }
    
    var selectedSTTLanguage: STTLanguage? {
        if let language = ForeignLanguages.shared.listLanguages.first(where: {
            $0.isSelected == true }) {
            return language
        }
        return nil
    }
    
    var selectedTransToLanguage: TranslationLanguage? {
        if let language = ForeignLanguages.shared.translatingLanguages.first(where: {
            $0.isSelected == true }) {
            return language
        }
        return nil
    }
}
