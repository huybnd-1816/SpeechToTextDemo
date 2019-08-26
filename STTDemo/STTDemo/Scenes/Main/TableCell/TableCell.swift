//
//  TableCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

enum SenderType : Int {
    case OnLeft = 0
    case OnRight
}

struct CellData {
    
    var strTextRecognizedFromSpeech : String = ""
    var strTextTranslated : String = ""
    var dataIndex : Int = 0
    var senderType : SenderType = .OnLeft
    
    // Constructor.
    init(givenTextRecog: String, givenTextTranslated: String, givenIndex: Int, givenSenderType: SenderType) {
        self.strTextRecognizedFromSpeech = givenTextRecog;
        self.strTextTranslated = givenTextTranslated;
        self.dataIndex = givenIndex
        self.senderType = givenSenderType
    }
}

protocol TableCellDelegate {
    func didPressCopyText(at index: IndexPath)
}

final class TableCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var lblTextRecognized: UILabel!
    @IBOutlet private weak var lblTextTranslated: UILabel!
    
    @IBOutlet weak var viewContentRight: UIView!
    @IBOutlet weak var viewContentLeft: UIView!
    
    var delegate: TableCellDelegate!
    var indexPath: IndexPath!
    
    var localCellData: CellData = CellData(givenTextRecog: "Recognizing",
                                            givenTextTranslated: "",
                                            givenIndex: 0,
                                            givenSenderType: SenderType.OnLeft)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configView()
        presentCellData()
    }
    
    func configView() {
        self.viewMain.cornerRadius = 7
        self.viewMain.layer.borderWidth = 2
    }
    
    func configCell(_ givenCellData: CellData, givenIndexPath: IndexPath) {
        self.localCellData = givenCellData
        self.indexPath = givenIndexPath
        self.presentCellData()
    }
    
    func presentCellData() {
        self.lblTextRecognized.text = self.localCellData.strTextRecognizedFromSpeech
        self.lblTextTranslated.text = self.localCellData.strTextTranslated
        self.handleActionCopyPaste()
    }
    
}

// MARK: - Actions Handler
extension TableCell {
    @IBAction func btnCopyTextDidPressed(_ sender: Any) {
        self.delegate?.didPressCopyText(at: indexPath)
    }
    
    func handleActionCopyPaste () {
        self.viewContentLeft.isHidden = self.localCellData.senderType != .OnLeft
        self.viewContentRight.isHidden = self.localCellData.senderType != .OnRight
    }
}
