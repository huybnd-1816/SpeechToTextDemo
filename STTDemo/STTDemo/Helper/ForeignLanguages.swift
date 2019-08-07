//
//  ForeignLanguages.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/5/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class ForeignLanguages {
    static let shared = ForeignLanguages()
    
    var listLanguages: [Language] = []
    var translatingLanguagues: [(translationCode: String, isSelected: Bool)] = []
    
    private init() {
        let japanese = Language(name: "Japanese", sttCode: STTLanguages.Japanese.getLangCode(), translationCode: TranslationLanguagues.Japanese.getLangCode(), isSelected: true)
        let english = Language(name: "English", sttCode: STTLanguages.English.getLangCode(), translationCode: TranslationLanguagues.English.getLangCode(), isSelected: false)
        listLanguages.append(contentsOf: [japanese, english])
        
        // TranslationTo Code
        translatingLanguagues = [(TranslationLanguagues.Vietnamese.getLangCode(), true), (TranslationLanguagues.English.getLangCode(), false)]
    }
    
    func getSelectedLanguage() -> Language? {
        if let language = ForeignLanguages.shared.listLanguages.first(where: {
            $0.isSelected == true }) {
            return language
        }
        return nil
    }
    
    func getTranslationToLanguage() -> String? {
        if let language = ForeignLanguages.shared.translatingLanguagues.first(where: {
            $0.isSelected == true
        }) {
            return language.translationCode
        }
        return nil
    }
}
