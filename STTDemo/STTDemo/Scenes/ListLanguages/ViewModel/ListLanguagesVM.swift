//
//  ListLanguagesVM.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/1/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class ListLanguagesVM: NSObject {
    var languageSelectionMode : LanguageSelectionMode = .SpeechToText
    
    override init() {
        super.init()
    }
}

extension ListLanguagesVM: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListLanguagesVM: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageHelper.shared.listLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCell(for: indexPath)
        
        let langItem = LanguageHelper.shared.listLanguage[indexPath.row]
        cell.configCell(givenLangItem: langItem, givenLanguageSelectionMode: self.languageSelectionMode)
//        cell.config(langName: langName, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch languageSelectionMode {
        case .SpeechToText:
            LanguageHelper.shared.setSelectedSTT(givenLangItem:LanguageHelper.shared.listLanguage[indexPath.row])
        case .Translation:
            LanguageHelper.shared.setSelectedTrans(givenLangItem:LanguageHelper.shared.listLanguage[indexPath.row])
        case .SpeakerLeft:
            LanguageHelper.shared.setSelectedSpeakerLeft(givenLangItem:LanguageHelper.shared.listLanguage[indexPath.row])
        case .SpeakerRight:
            LanguageHelper.shared.setSelectedSpeakerRight(givenLangItem:LanguageHelper.shared.listLanguage[indexPath.row])
        }
        
        tableView.reloadData()
    }
}
