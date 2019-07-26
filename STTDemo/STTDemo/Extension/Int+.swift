//
//  Int+.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

//Milliseconds to date
extension Int {
    func dateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}
