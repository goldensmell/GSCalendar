import Foundation

class GSCalendarModel: NSObject {
    
    var months = Array<GSCalendarMonthModel>()
    
    // 기본 설정 값들
    var defaultDisplayDistance = 12 // 기본 보여질 기준 월로 부터의 +,- 기간
    var monthStrings = ["January", "February","March","Aprill","May","June","July","August","September","October","November","December"]
    var dayStrings = ["Mon","Tue","Wen","Thu","Fri","Sat","Sun"]
    //["Monday", "Tuesday", "Wendnesday","Thursday","Friday","Saturday","Sunday"]
    var useLunar: Bool = true // 음력 사용
    var useDisplayOverMonth:Bool = true // 전월/이월 날짜 같이 표시
    var fixPeriod:Bool = false // 기간 고정
    var scrollDirection:Bool = true //스크롤 방향; true - horizon, false - vertical
    
    var startDate:Date?
    var endDate:Date?
    
    var currentDate = Date()
    var currentIndex = 1 // 컨트롤러에 보여지는 데이터 인덱스 ; 초기화시 오늘 날짜
    
    var lunarManage = LunarDataManage()
    
    private func initLunarData() {
        if useLunar {
            lunarManage.readLunarData()
        }
    }
    
    public func initDate() {
        initMonthLists()
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
    
    public func initData(BaseDate baseDate:Date?) {
        
        startDate = nil
        endDate = nil
        
        initDefaultDatas(BaseDate: baseDate, FixPeriod: fixPeriod, OverDisplay: useDisplayOverMonth, UseLunar: useLunar, ScrollDirection:scrollDirection)
        
        initLunarData()
    }
    
    // BaseDate = 먼저 표시될 기준 날짜
    public func initData(BaseDate baseDate:Date?, FixPeriod fixPeriod:Bool,StartDate start:Date, EndDate end:Date,  OverDisplay overDisplay:Bool, UseLunar useLunar:Bool, ScrollDirection direction:Bool) {
        
        startDate = start
        endDate = end
        
        initDefaultDatas(BaseDate: baseDate, FixPeriod: fixPeriod, OverDisplay: overDisplay, UseLunar: useLunar, ScrollDirection:direction)
        
        initLunarData()
    }
    
    private func chcekSameMonth(_ date:Date) -> Bool {
        
        var result = false
        
        let currentYear = currentDate.yearOfThisDate()
        let currentMonth = currentDate.monthOfThisDate()
        
        let thisYear = date.yearOfThisDate()
        let thisMonth = date.monthOfThisDate()
        
        if( currentYear == thisYear && currentMonth == thisMonth ){
            result = true
        }
        
        return result
    }
    
    private func initMonthLists() {
        
        months = Array<GSCalendarMonthModel>()
        
        if checkFixPeriod() == true {
            if let start = startDate, let end = endDate {
                
                // 설정한 날짜가 기간을 벚어나는 경우 시작 일은 시작하는 달
                if(start > currentDate || end < currentDate){
                    currentDate = start
                }
                
                var index = 0
                while true{
                    let thisDate:Date = start.moveMonthFromDate(move: index)
                    
                    // index 설정
                    if chcekSameMonth(thisDate) {
                        currentIndex = index
                    }
                    
                    let month = GSCalendarMonthModel()
                    month.initDate(SetDate: thisDate)
                    month.setPeriodDate(Start: start, End: end)
                    month.useDisplayOverMonth = useDisplayOverMonth
                    months.append(month)
                    if(thisDate >= end) {
                        break
                    }
                    
                    index = index + 1
                }
                
                return
            }
        }
        
        // 기준의 날짜로부터 +- (지정한)개월 데이터 셋팅
        for i in -(defaultDisplayDistance)..<defaultDisplayDistance {
            let thisDate:Date = currentDate.moveMonthFromDate(move: i)
            
            let month = GSCalendarMonthModel()
            month.initDate(SetDate: thisDate)
            month.useDisplayOverMonth = useDisplayOverMonth
            months.append(month)
        }
        
        currentIndex = defaultDisplayDistance
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
    
    public func checkFixPeriod()->Bool{
        return fixPeriod
    }
}


