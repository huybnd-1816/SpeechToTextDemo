//
//  TableCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class TableCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var resultTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configCell(_ dataCell: String) {
        resultTextLabel.text = dataCell
    }
}
