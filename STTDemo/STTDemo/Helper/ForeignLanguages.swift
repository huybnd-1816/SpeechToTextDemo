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

struct LanguageItem {
    var name: String?
    var langIndex : Int?
    
    var langCodeSTT: String?
    var langCodeTrans: String?
}

enum LanguageSelectionMode : Int {
    case SpeechToText = 0
    case Translation
    case SpeakerLeft
    case SpeakerRight
}

final class LanguageHelper {
    static let shared = LanguageHelper()
    var listLanguage : [LanguageItem] = []
    var currentSTT : LanguageItem?
    var currentTrans : LanguageItem?
    
    var currentSpeakerLeft : LanguageItem?
    var currentSpeakerRight : LanguageItem?
    
    private init () {
        let viLang = LanguageItem(name: LanguageHelperItem.Vietnam.nameValue,
                                  langIndex: LanguageHelperItem.Vietnam.indexValue,
                                  langCodeSTT: LanguageHelperItem.Vietnam.sttCode,
                                  langCodeTrans: LanguageHelperItem.Vietnam.transCode)
        let japLang = LanguageItem(name: LanguageHelperItem.Japan.nameValue,
                                   langIndex: LanguageHelperItem.Japan.indexValue,
                                   langCodeSTT: LanguageHelperItem.Japan.sttCode,
                                   langCodeTrans: LanguageHelperItem.Japan.transCode)
        let enLang = LanguageItem(name: LanguageHelperItem.English.nameValue,
                                  langIndex: LanguageHelperItem.English.indexValue,
                                   langCodeSTT: LanguageHelperItem.English.sttCode,
                                   langCodeTrans: LanguageHelperItem.English.transCode)
        
        self.listLanguage.append(viLang)
        self.listLanguage.append(japLang)
        self.listLanguage.append(enLang)
        
        self.currentSTT = self.listLanguage[0]
        self.currentTrans = self.listLanguage[1]
        
        self.currentSpeakerLeft = self.listLanguage[0]
        self.currentSpeakerRight = self.listLanguage[1]
    }
    
    // Meeting mode
    func setSelectedSTT (givenLangItem : LanguageItem) {
        self.currentSTT = givenLangItem
    }
    
    func setSelectedTrans (givenLangItem : LanguageItem) {
        self.currentTrans = givenLangItem
    }
    
    func getCurrentSTT () -> LanguageItem {
        return self.currentSTT!
    }
    
    func getCurrentTrans () -> LanguageItem {
        return self.currentTrans!
    }
    
    // Conversation mode
    func setSelectedSpeakerLeft (givenLangItem : LanguageItem) {
        self.currentSpeakerLeft = givenLangItem
    }
    
    func setSelectedSpeakerRight (givenLangItem : LanguageItem) {
        self.currentSpeakerRight = givenLangItem
    }
    
    func getCurrentSpeakerLeft () -> LanguageItem {
        return self.currentSpeakerLeft!
    }
    
    func getCurrentSpeakerRight () -> LanguageItem {
        return self.currentSpeakerRight!
    }
}
