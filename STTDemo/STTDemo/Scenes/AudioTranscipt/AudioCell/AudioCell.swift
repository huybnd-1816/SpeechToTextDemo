//
//  MessageCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class AudioCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var audioNameLabel: UILabel!
    
    func configCell(audio: String) {
        audioNameLabel.text = audio
    }
}
