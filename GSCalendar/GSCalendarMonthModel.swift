import UIKit

class GSCalendarMonthModel: NSObject {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth: Int = 0
    var currentYear: Int = 0
    var currentDay = 0
    var firstWeekDayOfMonth = 0 // 첫주의 요일
    
    var displayTotalDate:Int = 0 // 달력에 표시될 총 날짜
    
    var days = [""] // 양력 날짜
    var lunarDays = [""] // 음력 날짜
    
    func initDate(SetDate date:Date) {
        
        currentMonth = Calendar.current.component(.month, from: date)
        currentYear = Calendar.current.component(.year, from: date)
        firstWeekDayOfMonth = getFirstWeekDay()
        //for leap years, make february month of 29 days
        if currentMonth == 2 && (currentYear % 4 == 0 || currentYear % 100 == 0 || currentYear % 400 == 0) {
            numOfDaysInMonth[currentMonth-1] = 29
        }
        displayTotalDate = getDisplayTotalDate()
        
        //end
        
        //표시될 날짜 리스트 생성
        days.removeAll()
        lunarDays.removeAll()
        
        for i in 0..<displayTotalDate {
            let  solar = getSolarDayString(i)
            let  lunar = getLunarDayString(i)
            days.append(solar)
            lunarDays.append(lunar)
        }
        
        currentDay = Calendar.current.component(.day, from: date)
    }
    
    // 해당 월의 1일의 요일 계산
    private func getFirstWeekDay() -> Int {
        
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    public func getDisplayTotalDate() -> Int {
        var dayCount = numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1
        if dayCount <= 28 {
            dayCount = 28 // 5주 치 표시 하기 위하여 7 * 5
        }else if dayCount > 28 && dayCount <= 35 {
            dayCount = 35
        }else {
            dayCount = 42
        }
    
        return dayCount
    }
    
    public func getCurrentDate() -> Date {
        return "\(currentYear)-\(currentMonth)-01".date!
    }
    
    // 해당 월의 타이틀 스트링
    public func getMonthString() -> String{
        
        let result = "\(currentYear) \(GSCalendarCommon.months[currentMonth - 1])"
        
        return result
    }
    
    private func getRealDateOfMonth() -> Int{
        return numOfDaysInMonth[currentMonth-1]
    }
    
    // 양력 / 음력 표시될 날짜 출력
    private func getSolarDayString(_ index:Int) -> (String) {
        var solar = ""
        var date = Date()
        
        if(index <= firstWeekDayOfMonth - 2){
            let diffDateNum = index - firstWeekDayOfMonth + 2 - 1
            let firstDate = "\(currentYear)-\(currentMonth)-1"
            date = ("\(firstDate)".date?.addDayFromDate(addDay: diffDateNum))!
            solar = "\(date.dayOfThisDate())"
            
        }else if(index > numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2){
            let diffDateNum = index - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2)
            let lastDate = "\(currentYear)-\(currentMonth)-\(getRealDateOfMonth())"
            date = ("\(lastDate)".date?.addDayFromDate(addDay: diffDateNum))!
            solar = "\(date.dayOfThisDate())"
        }else {
            let calcDate = index-firstWeekDayOfMonth+2
            solar = "\(calcDate)"
        }
       
        return solar
    }
    
    private func getLunarDayString(_ index:Int) -> (String) {
        var lunar = ""
        var date = Date()
        
        if(index <= firstWeekDayOfMonth - 2){
            let diffDateNum = index - firstWeekDayOfMonth + 2 - 1
            let firstDate = "\(currentYear)-\(currentMonth)-1"
            date = ("\(firstDate)".date?.addDayFromDate(addDay: diffDateNum))!
            
        }else if(index > numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2){
            let diffDateNum = index - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2)
            let lastDate = "\(currentYear)-\(currentMonth)-\(getRealDateOfMonth())"
            date = ("\(lastDate)".date?.addDayFromDate(addDay: diffDateNum))!
        }else {
            let calcDate = index-firstWeekDayOfMonth+2
            date = ("\(currentYear)-\(currentMonth)-\(calcDate)".date)!
        }
        
        let lunarManage = Lunar()
        let lunarDateDic = lunarManage.solar2lunar(solar_date: date)
        lunar = "\(lunarDateDic["month"]!).\(lunarDateDic["day"]!)"
        
        return lunar
    }
    
    
    
    // 표시할 날짜
    public func getDay(_ index:Int) -> (Bool,String,String) {
        
        var isThisMonth = false
        let solar = days[index]
        let lunar = lunarDays[index]
        
        if(index > firstWeekDayOfMonth - 2 && index <= numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2){
            
             isThisMonth = true
        }
        
        
        
        return (isThisMonth,solar, lunar)
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
    
   

}

