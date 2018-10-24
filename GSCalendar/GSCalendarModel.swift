import Foundation

class GSCalendarModel: NSObject {
    
    var months = Array<GSCalendarMonthModel>()
    
    var monthStrings = ["January", "February","March","Aprill","May","June","July","August","September","October","November","December"]
    var dayStrings = ["Mon","Tue","Wen","Thu","Fri","Sat","Sun"]
    //["Monday", "Tuesday", "Wendnesday","Thursday","Friday","Saturday","Sunday"]
    var useLunar: Bool = true
    var useDisplayOverMonth:Bool = true
    
    var currentDate = Date()
    var currentIndex = 6 // 컨트롤러에 보여지는 데이터 인덱스 ; 초기화시 오늘 날짜
    
    var lunarManage = LunarDataManage()
    
    public func initLunarData() {
        lunarManage.readLunarData()
    }
    
    public func initDate(date:Date) {
        currentDate = date
        initMonthLists()
    }
    
    private func initMonthLists() {
        
        months = Array<GSCalendarMonthModel>()
        
        // 기준의 날짜로부터 +- 6개월 데이터 셋팅
        for i in -12..<12 {
            let thisDate:Date = currentDate.moveMonthFromDate(move: i)

            let month = GSCalendarMonthModel()
            month.initDate(SetDate: thisDate)
            months.append(month)
        }

        currentIndex = 12
    }
    
    public func initLunarDataToMonth(_ index:Int) {
        let lunarDates = lunarManage.changeSolarsToLunars(months[index].days)
        months[index].setLunarDates(lunarDates)
    }
    
    public func setCurrent(_ index:Int){
        currentIndex = index
        currentDate = months[index].getCurrentDate()
    }
    
    // 현재 인덱스의 Title
    public func getCurrentMonthString() -> String {
        let year = months[currentIndex].currentYear
        let month = months[currentIndex].currentMonth
        
        return "\(year) \(monthStrings[month-1])"
    }
    
    // 요일 스트링
    public func getDayString(_ index:Int) -> String {
        
        return dayStrings[index]
    }
}


