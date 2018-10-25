import Foundation

class GSCalendarModel: NSObject {
    
    var months = Array<GSCalendarMonthModel>()
    
    // 기본 설정 값들
    var monthStrings = ["January", "February","March","Aprill","May","June","July","August","September","October","November","December"]
    var dayStrings = ["Mon","Tue","Wen","Thu","Fri","Sat","Sun"]
    //["Monday", "Tuesday", "Wendnesday","Thursday","Friday","Saturday","Sunday"]
    var useLunar: Bool = true
    var useDisplayOverMonth:Bool = true
    var fixPeriod:Bool = false
    var scrollDirection:Bool = true // true - horizon, false - vertical
    
    var currentDate = Date()
    var currentIndex = 6 // 컨트롤러에 보여지는 데이터 인덱스 ; 초기화시 오늘 날짜
    
    var lunarManage = LunarDataManage()
    
    private func initLunarData() {
        if useLunar {
            lunarManage.readLunarData()
        }
    }
    
    public func initDate(date:Date) {
        currentDate = date
        initMonthLists()
    }
    
    private func initDefaultDatas(BaseDate baseDate:Date?,FixPeriod fixPeriod:Bool, OverDisplay overDisplay:Bool, UseLunar useLunar:Bool, ScrollDirection direction:Bool) {
        
        if let date = baseDate {
            currentDate = date
        }else {
            currentDate = Date()
        }
        self.fixPeriod = fixPeriod
        
        useDisplayOverMonth = overDisplay
        self.useLunar = useLunar

        scrollDirection = direction
        
        initMonthLists()
    }
    
    // BaseDate = 먼저 표시될 기준 날짜
    public func initData(BaseDate baseDate:Date?,FixPeriod fixPeriod:Bool, OverDisplay overDisplay:Bool, UseLunar useLunar:Bool, ScrollDirection direction:Bool) {
        
        initDefaultDatas(BaseDate: baseDate, FixPeriod: fixPeriod, OverDisplay: overDisplay, UseLunar: useLunar, ScrollDirection:direction)
        
        initLunarData()
    }
    
    // BaseDate = 먼저 표시될 기준 날짜
    public func initData(BaseDate baseDate:Date?, FixPeriod fixPeriod:Bool,StartDate start:Date, EndDate end:Date,  OverDisplay overDisplay:Bool, UseLunar useLunar:Bool, ScrollDirection direction:Bool) {
        
        initDefaultDatas(BaseDate: baseDate, FixPeriod: fixPeriod, OverDisplay: overDisplay, UseLunar: useLunar, ScrollDirection:direction)
        
        initLunarData()
    }
    
    private func initMonthLists() {
        
        months = Array<GSCalendarMonthModel>()
        
        // 기준의 날짜로부터 +- 6개월 데이터 셋팅
        for i in -12..<12 {
            let thisDate:Date = currentDate.moveMonthFromDate(move: i)

            let month = GSCalendarMonthModel()
            month.initDate(SetDate: thisDate)
            month.useDisplayOverMonth = useDisplayOverMonth
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
    
    public func getScrollOrient()->Bool{
        return scrollDirection
    }
}

