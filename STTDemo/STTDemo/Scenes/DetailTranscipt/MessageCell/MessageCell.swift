//
//  MessageCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/6/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

//final class MessageCell: UITableViewCell, NibReusable {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        selectionStyle = .none
//    }
//
//    func configDetailCell(data: MessageModel) {
//        messageLabel.text = data.content
//    }
//}
protocol MessageCellDelegate {
    func didPressCopyText(_ copyText: String)
}

final class MessageCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var textRecognizedLabel: UILabel!
    @IBOutlet private weak var textTranslatedLabel: UILabel!
    
    var delegate: MessageCellDelegate!
    
    var localCellData: CellData = CellData(givenTextRecog: "Recognizing",
                                           givenTextTranslated: "",
                                           givenIndex: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configView()
        presentCellData()
    }
    
    func configView() {
        viewMain.cornerRadius = 7
        viewMain.layer.borderWidth = 2
    }
    
    func configDetailCell(_ givenCellData: MessageModel, givenIndexPath: IndexPath) {
        if givenCellData.content.contains("[&]") {
            let givenDataArray = givenCellData.content.components(separatedBy: "[&]")
            
            localCellData.strTextRecognizedFromSpeech = givenDataArray[0]
            localCellData.strTextTranslated = givenDataArray[1]
        } else {
            localCellData.strTextTranslated = givenCellData.content
        }

        presentCellData()
    }
    
    func presentCellData() {
        textRecognizedLabel.text = localCellData.strTextRecognizedFromSpeech
        textTranslatedLabel.text = localCellData.strTextTranslated
    }
    
    @IBAction func btnCopyTextDidPressed(_ sender: Any) {
        delegate?.didPressCopyText(localCellData.strTextRecognizedFromSpeech)
    }
}
