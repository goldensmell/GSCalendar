import UIKit

class GSCalendarCommon: NSObject {
    // MARK: - static data
    // 윤달 계산으로 인하여 var로 선언
    static let months = ["January", "February","March","Aprill","May","June","July","August","September","October","November","December"]
    static let days = ["Mon","Tue","Wen","Thu","Fri","Sat","Sun"]
    //["Monday", "Tuesday", "Wendnesday","Thursday","Friday","Saturday","Sunday"]
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    var getDaysComponent: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month,.day], from: self))!
    }
    
    func moveMonthFromDate(move:Int)->Date {
        let month = DateComponents(month:move)
        let resultDate = Calendar.current.date(byAdding: month, to: self)
        return resultDate!
    }
    
    func addDayFromDate(addDay:Int)->Date {
        let dayComponent = DateComponents(day:addDay)
        let resultDate = Calendar.current.date(byAdding: dayComponent, to: self)
        return resultDate!
    }
    
    func dayOfThisDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let result = formatter.string(from: self)
        
        return Int(result)!
    }
    
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
