//
//  MessageCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class MessageCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func configCell(data: MessageModel) {
        messageLabel.text = data.content
    }
}
