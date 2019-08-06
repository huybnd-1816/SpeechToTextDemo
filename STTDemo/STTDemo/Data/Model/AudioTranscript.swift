//
//  AudioTranscript.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/6/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

class AudioTranscript {
    var title: Date
    var audios: [String] = []
    
    init(title: Date) {
        self.title = title
    }
}
