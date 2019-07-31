//
//  String+.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


extension String {
    func dateBy(format: String, calendar: Calendar = Calendar(identifier: .gregorian), timeZone: TimeZone? = TimeZone.current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
}
