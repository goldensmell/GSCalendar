import UIKit

class GSCalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    // year & month
    @IBOutlet weak var current: UIButton!
    
    //day
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var four: UILabel!
    @IBOutlet weak var five: UILabel!
    @IBOutlet weak var six: UILabel!
    @IBOutlet weak var seven: UILabel!
    
    var calendar :GSCalendar = GSCalendar()
    
    var monthVieweControllers:[GSCalendarMonthCollectionViewController?] = Array<GSCalendarMonthCollectionViewController>()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setDayUI()
        setScrollOrient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendarData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)
        
        calendarCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.moveCurrentSetMonth()
        }
    }
    
    public func initCalendar(Calendar calendar:GSCalendar){
        self.calendar = calendar
    }
    
    private func moveToday(){
        let now = Date()
        calendar.initDate(date: now)
        setCalendarData()
    }
    
    private func moveSelectDay(_ date:Date){
        calendar.initDate(date: date)
        setCalendarData()
    }
    
    private func setCalendarData(){
        for _ in 0..<calendar.months.count {
            monthVieweControllers.append(nil)
        }
        
        setTitle()
        
        calendarCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.moveCurrentSetMonth()
        }
    }
    
    private func setTitle(){
        current.setTitle(calendar.getCurrentMonthString(), for: .normal)
        current.setTitle(calendar.getCurrentMonthString(), for: .highlighted)
    }
    
    private func setCurrentMonth (_ index:Int){
        if index != calendar.currentIndex {
            calendar.setCurrent(index)
            setTitle()
        }
    }
    
    private func reloadCalendarData(_ index:Int){
        if (calendar.checkFixPeriod() == false && (index == 0 || (index == (calendar.months.count-1))) ){
            calendar.initDate()
            setCalendarData()
            return
        }
    }
    
    private func setDayUI() {
        one.text = calendar.getDayString(6)
        two.text = calendar.getDayString(0)
        three.text = calendar.getDayString(1)
        four.text = calendar.getDayString(2)
        five.text = calendar.getDayString(3)
        six.text = calendar.getDayString(4)
        seven.text = calendar.getDayString(5)
    }
    
    private func setScrollOrient(){
        
        if let layout = calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if calendar.getScrollOrient() {
                layout.scrollDirection = .horizontal
            }else {
                layout.scrollDirection = .vertical
            }
            
        }
    }
    
    private func moveCurrentSetMonth(){
        calendarCollectionView.scrollToItem(at: IndexPath(item: calendar.currentIndex, section: 0), at:[.centeredVertically, .centeredHorizontally], animated: false)
    }
    
    private func getMonthVC(Index index:Int) -> GSCalendarMonthCollectionViewController?{

        if let monthVC = self.storyboard?.instantiateViewController(withIdentifier: "GSCalendarMonthCollectionViewController") as? GSCalendarMonthCollectionViewController {
            calendar.initLunarDataToMonth(index)
            monthVC.setinit(month: calendar.months[index])
            var frame = calendarCollectionView.frame
            frame.origin.x = 0
            frame.origin.y = 0
            monthVC.view.frame = frame
            
            monthVieweControllers[index] = monthVC
            return monthVC
        }
        
        return nil
    }
    
    //MARK: - ACTION METHOD
    
    @IBAction func moveToday(_ sender: UIButton) {
        moveToday()
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        let alert = UIAlertController(title: "날짜 선택", message: "\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        
        let datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        datePicker.datePickerMode = .date
        
        if calendar.checkFixPeriod() {
            if let start = calendar.startDate, let end = calendar.endDate {
                datePicker.minimumDate = start
                datePicker.maximumDate = end
            }
        }
        
        alert.view.addSubview(datePicker)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.moveSelectDay(datePicker.date)
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        self.parent!.present(alert, animated: true, completion: { })
    }
    
    //MARK: - COLLECTION VIEW METHOD
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendar.months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GSCalendarCollectionViewCell", for: indexPath) as! GSCalendarCollectionViewCell
        
        //cell.backgroundColor = UIColor.brown
        
        for v in cell.subviews {
            v.removeFromSuperview()
        }

        if let monthVC = getMonthVC(Index: indexPath.row) {
            cell.addSubview(monthVC.view)
            monthVC.view.layoutIfNeeded()
            monthVC.collectionView.reloadData()
        }
        
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("\(indexPath.row)")
//    }
    
    //MARK: - SCROLLVIEW DELEGATE
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleRect = CGRect(origin: calendarCollectionView.contentOffset, size: calendarCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = calendarCollectionView.indexPathForItem(at: visiblePoint) {
            
            // set current index
            self.setCurrentMonth(visibleIndexPath.row)
            self.reloadCalendarData(visibleIndexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: calendarCollectionView.contentOffset, size: calendarCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = calendarCollectionView.indexPathForItem(at: visiblePoint) {
            
            // set current index
            self.setCurrentMonth(visibleIndexPath.row)
        }
    }
}

//MARK: -
class GSCalendarCollectionViewCell: UICollectionViewCell {

}
