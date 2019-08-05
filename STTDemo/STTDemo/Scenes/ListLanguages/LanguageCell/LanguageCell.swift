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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func config(langName: String, isSelected: Bool) {
        checkBoxButton.isSelected = isSelected
        langNameLabel.text = langName
    }
}
