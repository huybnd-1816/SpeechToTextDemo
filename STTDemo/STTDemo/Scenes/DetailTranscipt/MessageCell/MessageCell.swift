//
//  MessageCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/6/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class MessageCell: UITableViewCell, NibReusable {
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configDetailCell(data: MessageModel) {
        messageLabel.text = data.content
    }
}
