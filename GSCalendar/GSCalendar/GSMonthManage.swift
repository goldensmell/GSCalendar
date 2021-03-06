import UIKit

class GSMonthManage: NSObject {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth: Int = 0
    var currentYear: Int = 0
    var currentDay = 0
    var firstWeekDayOfMonth = 0 // 첫주의 요일
    
    var useDisplayOverMonth = true
    
    var displayTotalDate:Int = 0 // 달력에 표시될 총 날짜
    
    var days:Array<Date> = [Date]() // 양력 날짜
    var lunarDays:Array<String?>? // 음력 날짜
    
    // 설정 date
    var startDate:Date?
    var endDate:Date?
    
    enum MonthType {
        case Before
        case Current
        case Next
    }
    
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
        setSolarDates()
        
        currentDay = Calendar.current.component(.day, from: date)
    }
    
    func setPeriodDate(Start start:Date, End end:Date){
        startDate = start
        endDate = end
    }
    
    func checkInPeriodDate(index:Int) -> Bool {
        
        let thisDate = getSolarDay(index)
        
        if let start = startDate, let end = endDate {
            if (start <= thisDate && thisDate <= end){
                return true
            }
        }
        
        return false
    }
    
    private func setSolarDates(){
        for i in 0..<displayTotalDate {
            let  solar = getSolarDay(i)
            days.append(solar)
        }
    }
    
    public func setLunarDates(_ list:Array<String>){
        lunarDays = list
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
    
    private func getRealDateOfMonth() -> Int{
        return numOfDaysInMonth[currentMonth-1]
    }
    
    private func checkMonthType(_ index:Int) -> MonthType {
        var monthType:MonthType = .Current
        
        if(index <= firstWeekDayOfMonth - 2){
           monthType = .Before
        }else if(index > numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2){
            monthType = .Next
        }
        
        return monthType
    }
    
    // 양력 날짜데이터 얻기
    private func getSolarDay(_ index:Int) -> Date {
        var date = Date()
        
        switch checkMonthType(index) {
        case .Before:
            let diffDateNum = index - firstWeekDayOfMonth + 2 - 1
            let firstDate = "\(currentYear)-\(currentMonth)-1"
            date = ("\(firstDate)".date?.addDayFromDate(addDay: diffDateNum))!
        case .Current:
            let calcDate = index-firstWeekDayOfMonth+2
            date = ("\(currentYear)-\(currentMonth)-\(calcDate)".date)!
        case .Next:
            let diffDateNum = index - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2)
            let lastDate = "\(currentYear)-\(currentMonth)-\(getRealDateOfMonth())"
            date = ("\(lastDate)".date?.addDayFromDate(addDay: diffDateNum))!
        }
       
        return date
    }
    
    // 표시할 날짜
    public func getDay(_ index:Int) -> (Bool,String,String?) {
        
        var isThisMonth = false
        let solar = "\(days[index].dayOfThisDate())"
        var lunar = ""
        if let lunarDate = lunarDays?[index]?.date {
            lunar = "\(lunarDate.monthOfThisDate()).\(lunarDate.dayOfThisDate())"
        }
        
        // 현재 월에 포함 된 날짜인지 확인
        if(index > firstWeekDayOfMonth - 2 && index <= numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 2){
            if startDate != nil && endDate != nil {
                if checkInPeriodDate(index: index) {
                    isThisMonth = true
                }
            }else{
                isThisMonth = true
            }
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
    
    // 오늘 날짜 check
    public func checkCurrentDay(_ index:Int) -> Bool {
        var result = false
        
        let today = Date()
        let todayYear = today.yearOfThisDate()
        let todayMonth = today.monthOfThisDate()
        let todayDay = today.dayOfThisDate()
        
        let thisDate = getSolarDay(index)
        let thisYear = thisDate.yearOfThisDate()
        let thisMonth = thisDate.monthOfThisDate()
        let thisDay = thisDate.dayOfThisDate()
        
        if( todayYear == thisYear && todayMonth == thisMonth && todayDay == thisDay){
            print(index)
            result = true
        }
        
        return result
    }
    
    public func getUseDisplayOverMonth() -> Bool{
    
        return useDisplayOverMonth
    }

}

