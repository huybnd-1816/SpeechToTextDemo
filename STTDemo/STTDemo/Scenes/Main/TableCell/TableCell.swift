//
//  TableCell.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct CellData {
    
    var strTextRecognizedFromSpeech : String = ""
    var strTextTranslated : String = ""
    var dataIndex : Int = 0
    
    // Constructor.
    init(givenTextRecog:String, givenTextTranslated:String, givenIndex : Int) {
        self.strTextRecognizedFromSpeech = givenTextRecog;
        self.strTextTranslated = givenTextTranslated;
        self.dataIndex = givenIndex
    }
}

final class TableCell: UITableViewCell, NibReusable {
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet private weak var resultTextLabel: UILabel!
    @IBOutlet weak var lblTextRecognized: UILabel!
    @IBOutlet weak var lblTextTranslated: UILabel!
    
    var localCellData : CellData = CellData(givenTextRecog: "Recognizing",
                                            givenTextTranslated: "",
                                            givenIndex: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.configView()
        
        self.presentCellData()
    }
    
    func configView () {
        self.viewMain.cornerRadius = 7
        self.viewMain.layer.borderWidth = 2
    }
    
    func configCell(_ givenCellData: CellData) {
        self.localCellData = givenCellData
        self.presentCellData()
    }
    
    func presentCellData () {
        self.lblTextRecognized.text = self.localCellData.strTextRecognizedFromSpeech
        self.lblTextTranslated.text = self.localCellData.strTextTranslated
    }
}
