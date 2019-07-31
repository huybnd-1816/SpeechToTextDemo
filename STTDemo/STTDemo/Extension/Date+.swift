//
//  Date+.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


extension Date {
    //Date to milliseconds
    static func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    
    static let currentCalendar = Calendar(identifier: .gregorian)
    static let currentTimeZone = TimeZone.ReferenceType.local
    
    init(year: Int, month: Int, day: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }

    init(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.hour = hour
        dc.minute = minute
        dc.second = second
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }

    var currentAge: Int? {
        let ageComponents = Date.currentCalendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year
    }

    var yesterday: Date? {
        return Date.currentCalendar.date(byAdding: .day, value: -1, to: self)
    }
    var tomorrow: Date? {
        return Date.currentCalendar.date(byAdding: .day, value: 1, to: self)
    }

    var weekday: Int {
        return Date.currentCalendar.component(.weekday, from: self)
    }

    var firstDayOfTheMonth: Date? {
        let calendar = Date.currentCalendar
        return calendar.date(from: calendar.dateComponents([.year,.month], from: self))
    }

    func isToday(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInToday(self)
    }

    func isYesterday(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInYesterday(self)
    }

    func isTomorrow(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInTomorrow(self)
    }

    func isWeekend(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInWeekend(self)
    }

    func isSamedayWith(date: Date, calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }

    func getComponents(calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            era: calendar.component(.era, from: self),
                                            year: calendar.component(.year, from: self),
                                            month: calendar.component(.month, from: self),
                                            day: calendar.component(.day, from: self),
                                            hour: calendar.component(.hour, from: self),
                                            minute: calendar.component(.minute, from: self),
                                            second: calendar.component(.second, from: self),
                                            nanosecond: calendar.component(.nanosecond, from: self),
                                            weekday: calendar.component(.weekday, from: self),
                                            weekdayOrdinal: calendar.component(.weekdayOrdinal, from: self),
                                            quarter: calendar.component(.quarter, from: self),
                                            weekOfMonth: calendar.component(.weekOfMonth, from: self),
                                            weekOfYear: calendar.component(.weekOfYear, from: self),
                                            yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self))
        return dateComponents
    }

    static func startOfMonth(date: Date, calendar: Calendar = Date.currentCalendar) -> Date? {
        let calendar = Date.currentCalendar
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: date)))
    }

    static func getComponentFrom(string: String, format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents? {
        if let date = getDateBy(string: string, format: format, calendar: calendar, timeZone: timeZone) {
            return date.getComponents(calendar: calendar, timeZone: timeZone)
        }
        return nil
    }

    static func endOfMonth(date: Date, calendar: Calendar = Date.currentCalendar) -> Date? {
        if let startOfMonth = startOfMonth(date: date, calendar: calendar) {
            return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        }
        return nil
    }

    static func dayEndOfMonth(date: Date, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Int {
        if let startOfMonth = startOfMonth(date: date, calendar: calendar) {
            if let day = (calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)?.getComponents(calendar: calendar, timeZone: timeZone).day) {
                return day
            }
        }
        return -1
    }

    static func getDateBy(string: String, format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.date(from: string)
    }

    static func dateAt(timeInterval: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        return date.getComponents(calendar: calendar, timeZone: timeZone)
    }

    static func getHourMinuteSecondFrom(secondValue: Int) -> (hour: Int, minute: Int, second: Int) {
        return (secondValue / 3600, (secondValue % 3600) / 60, (secondValue % 3600) % 60)
    }

    public static func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

    public static func hourBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: start, to: end).hour!
    }

    func add(day: Int? = nil, month: Int? = nil, year: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, calendar: Calendar = Date.currentCalendar) -> Date? {
        var dateComponent = DateComponents()
        if let year = year { dateComponent.year = year }
        if let month = month { dateComponent.month = month }
        if let day = day { dateComponent.day = day }
        if let hour = hour { dateComponent.hour = hour }
        if let minute = minute { dateComponent.minute = minute }
        if let second = second { dateComponent.second = second }
        return calendar.date(byAdding: dateComponent, to: self)
    }

    func stringBy(format: String = "dd/MM/yyyy hh:mm:ss", calendar: Calendar = Calendar.current, timeZone: TimeZone = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }

    func years(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }

    func months(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }

    func weeks(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    func days(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }

    func hours(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    func minutes(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    func seconds(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }

    func set(year: Int, month: Int, day: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        return self.set(year: year, calendar: calendar, timeZone: timeZone)?
            .set(month: month, calendar: calendar, timeZone: timeZone)?
            .set(day: day, calendar: calendar, timeZone: timeZone)
    }

    func set(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        return self.set(hour: hour, calendar: calendar, timeZone: timeZone)?
            .set(minute: minute, calendar: calendar, timeZone: timeZone)?
            .set(second: second, calendar: calendar, timeZone: timeZone)
    }

    func set(year: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.getComponents(calendar: calendar, timeZone: timeZone)
        components.year = year
        return calendar.date(from: components)
    }

    func set(month: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.getComponents(calendar: calendar, timeZone: timeZone)
        components.month = month
        return calendar.date(from: components)
    }

    func set(day: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.getComponents(calendar: calendar, timeZone: timeZone)
        components.day = day
        return calendar.date(from: components)
    }

    func set(hour: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.getComponents(calendar: calendar, timeZone: timeZone)
        components.hour = hour
        return calendar.date(from: components)
    }

    func set(minute: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.getComponents(calendar: calendar, timeZone: timeZone)
        components.minute = minute
        return calendar.date(from: components)
    }

    func set(second: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.getComponents(calendar: calendar, timeZone: timeZone)
        components.second = second
        return calendar.date(from: components)
    }

    var month: Int {
        return Calendar(identifier: .gregorian).component(.month, from: self)
    }
    var day: Int {
        return Calendar(identifier: .gregorian).component(.day, from: self)
    }
    var year: Int {
        return Calendar(identifier: .gregorian).component(.year, from: self)
    }
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }

    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }

    var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }

    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 7  {
            
            return self.stringBy(format: "MM/dd/yyyy", calendar: Date.currentCalendar, timeZone: Date.currentTimeZone)
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval >= 1, interval < 2  {
            
            return "Yesterday"
        }
        
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval >= 2 {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "Just now"
    }

}
