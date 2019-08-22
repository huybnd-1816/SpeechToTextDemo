//
//  TableCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct CellData {
    
    var strTextRecognizedFromSpeech: String = ""
    var strTextTranslated: String = ""
    var dataIndex: Int = 0
    
    // Constructor.
    init(givenTextRecog: String, givenTextTranslated: String, givenIndex: Int) {
        self.strTextRecognizedFromSpeech = givenTextRecog;
        self.strTextTranslated = givenTextTranslated;
        self.dataIndex = givenIndex
    }
}

protocol TableCellDelegate {
    func didPressCopyText(at index: IndexPath)
}

final class TableCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var lblTextRecognized: UILabel!
    @IBOutlet private weak var lblTextTranslated: UILabel!
    
    var delegate: TableCellDelegate!
    var indexPath: IndexPath!
    
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
    }
    
    @IBAction func btnCopyTextDidPressed(_ sender: Any) {
        self.delegate?.didPressCopyText(at: indexPath)
    }
    
}
