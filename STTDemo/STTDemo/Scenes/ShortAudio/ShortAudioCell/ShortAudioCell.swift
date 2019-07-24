//
//  ShortAudioCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class ShortAudioCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var shortAudioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configShortAudioCell(_ dataCell: String) {
        shortAudioLabel.text = dataCell
    }
    
}
