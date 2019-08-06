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
    
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9\\s].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
}
