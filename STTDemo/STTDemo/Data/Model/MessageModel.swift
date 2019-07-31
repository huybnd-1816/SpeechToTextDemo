//
//  MessageModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import SwiftyJSON

struct MessageModel {
    var time: Date
    var content: String
    
    init(time: Date, content: String) {
        self.time = time
        self.content = content
    }
    
    init(json: JSON) {
        time = json["time"].stringValue.dateBy(format: "dd/MM/yyyy hh:mm:ss") ?? Date()
        content = json["content"].stringValue
    }
    
    func dictValue() -> [String : Any] {
        return ["time" : self.time.stringBy(), "content" : self.content]
    }
}
