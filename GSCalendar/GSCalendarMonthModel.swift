import UIKit

class GSCalendarMonthModel: NSObject {
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth: Int = 0
    var currentYear: Int = 0
    var currentDay = 0
    var firstWeekDayOfMonth = 0 // 첫주의 요일
    
    func initDate(SetDate date:Date) {
        
        currentMonth = Calendar.current.component(.month, from: date)
        currentYear = Calendar.current.component(.year, from: date)
        firstWeekDayOfMonth = getFirstWeekDay()
        //for leap years, make february month of 29 days
        if currentMonth == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonth-1] = 29
        }
        //end
        
        currentDay = Calendar.current.component(.day, from: date)
    }
    
    // 해당 월의 1일의 요일 계산
    private func getFirstWeekDay() -> Int {
        
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    public func getCurrentDate() -> Date {
        return "\(currentYear)-\(currentMonth)-01".date!
    }
    
    // 해당 월의 타이틀 스트링
    public func getMonthString() -> String{
        
        let result = "\(currentYear) \(GSCalendarCommon.months[currentMonth - 1])"
        
        return result
    }
    
    // 해당 월의 총 날짜
    public func getDateOfMonth() -> Int {
        var dayCount = numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1
        if dayCount == 28 {
            dayCount = 35 // 5주 치 표시 하기 위하여 7 * 5
        }
        
        return 35
    }
    
    private func getRealDateOfMonth() -> Int{
        return numOfDaysInMonth[currentMonth-1]
    }
    
    // 일요일 체크
    public func checkSunday(_ index:Int) -> Bool{
        var result = false
        
        if( index > getRealDateOfMonth() ) {
            return result
        }
        
        let day = ("\(currentYear)-\(currentMonth)-\(index)".date?.getDaysComponent.weekday)!
        
        if day == 1 {
            result = true
        }
        
        return result
    }
    
    // 토요일 체크
    public func checkSaturday(_ index:Int) -> Bool{
        var result = false
        
        if( index > getRealDateOfMonth() ) {
            return result
        }
        
        let day = ("\(currentYear)-\(currentMonth)-\(index)".date?.getDaysComponent.weekday)!
        
        if day == 7 {
            result = true
        }
        
        return result
    }
    
    //TODO: 오늘 날짜 check
    public func checkCurrentDay(_ index:Int) -> Bool {
        var result = false
        
        //        if( currentYear == presentYear && currentMonth == presentMonth && index == currentDay){
        //            result = true
        //        }
        
        return result
    }
    
    // 표시할 날짜
    public func getDay(_ index:Int) -> (Bool,String) {
        
        var isThisMonth = false
        var day = ""
        if(index <= firstWeekDayOfMonth - 2){
            let diffDateNum = index - firstWeekDayOfMonth + 2 - 1
            
            let firstDate = "\(currentYear)-\(currentMonth)-1"
            let diffDate = "\(firstDate)".date?.addDayFromDate(addDay: diffDateNum)
            day = "\(diffDate!.dayOfThisDate())"
            
        }else if(index > numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2){
            
            let diffDateNum = index - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2)
            
            let lastDate = "\(currentYear)-\(currentMonth)-\(getRealDateOfMonth())"
            let diffDate = "\(lastDate)".date?.addDayFromDate(addDay: diffDateNum)
            day = "\(diffDate!.dayOfThisDate())"
        }else {
            isThisMonth = true
            let calcDate = index-firstWeekDayOfMonth+2
            day = "\(calcDate)"
        }
        
        return (isThisMonth,day)
    }

}

