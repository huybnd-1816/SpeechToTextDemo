//
//  AudioCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class AudioCell: UITableViewCell, NibReusable {
    @IBOutlet weak var audioLabel: UILabel!
    
    var didDeleteAudio: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configAudioCell(_ dataCell: String) {
        audioLabel.text = dataCell
    }
    
    @IBAction private func handleDeleteButtonTapped(_ sender: Any) {
        didDeleteAudio?()
    }
}
