//
//  LanguageCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/1/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class LanguageCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var langNameLabel: UILabel!
    @IBOutlet private weak var checkBoxButton: UIButton!
    
    var localLanguageItem : LanguageItem?
    var languageSelectionMode : LanguageSelectionMode = .SpeechToText
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        self.checkBoxButton.isSelected = false
    }
    
    func config(langName: String, isSelected: Bool) {
        checkBoxButton.isSelected = isSelected
        langNameLabel.text = langName
    }
    
    func configCell (givenLangItem : LanguageItem, givenLanguageSelectionMode : LanguageSelectionMode) {
        self.localLanguageItem = givenLangItem
        self.languageSelectionMode = givenLanguageSelectionMode
        
        self.configCellPresent()
    }
    
    func configCellPresent () {
        self.checkBoxButton.isSelected = false
                
        switch languageSelectionMode {
        case .SpeechToText:
            self.checkBoxButton.isSelected = self.localLanguageItem?.langIndex == LanguageHelper.shared.getCurrentSTT().langIndex
        case .Translation:
            self.checkBoxButton.isSelected = self.localLanguageItem?.langIndex == LanguageHelper.shared.getCurrentTrans().langIndex
        case .SpeakerLeft:
            self.checkBoxButton.isSelected = self.localLanguageItem?.langIndex == LanguageHelper.shared.getCurrentSpeakerLeft().langIndex
        case .SpeakerRight:
            self.checkBoxButton.isSelected = self.localLanguageItem?.langIndex == LanguageHelper.shared.getCurrentSpeakerRight().langIndex
        }
        
        self.langNameLabel.text = self.localLanguageItem?.name
    }
}
