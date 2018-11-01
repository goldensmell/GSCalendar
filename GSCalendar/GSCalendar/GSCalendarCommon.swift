import UIKit

class GSCalendarCommon: NSObject {
    // MARK: - static data
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
    
    func yearOfThisDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let result = formatter.string(from: self)
        
        return Int(result)!
    }
    func monthOfThisDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let result = formatter.string(from: self)
        
        return Int(result)!
    }
    func dayOfThisDate() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let result = formatter.string(from: self)
        
        return Int(result)!
    }
    
    func getDefaultString() -> String{
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        return dateFormatter.string(from: self)
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
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
