import UIKit

class GSCalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    // year & month
    @IBOutlet weak var current: UILabel!
    
    //day
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var four: UILabel!
    @IBOutlet weak var five: UILabel!
    @IBOutlet weak var six: UILabel!
    @IBOutlet weak var seven: UILabel!
    
    var calendar :GSCalendarModel = GSCalendarModel()
    
    override func viewWillLayoutSubviews() {
        setDayUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveToday()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.moveCurrentSetMonth()
        }
    }
    
    private func moveCurrentSetMonth(){
        calendarCollectionView.scrollToItem(at: IndexPath(item: calendar.currentIndex, section: 0), at:[.centeredVertically, .centeredHorizontally], animated: false)
    }
    
    private func moveToday(){
        let now = Date()
        setInitDate(now)
    }
    
    private func setInitDate(_ date:Date){
        calendar.initDate(date: date)
        setTitle()
        
        calendarCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.moveCurrentSetMonth()
        }
    }
    
    private func setTitle(){
        current.text = calendar.getCurrentMonthString()
    }
    
    private func setCurrentMonth (_ index:Int){
        
        if index != calendar.currentIndex {
            
            calendar.setCurrent(index)
            setTitle()
            
            if ( (index == 0) || (index == (calendar.months.count-1)) ){
                setInitDate(calendar.currentDate)
                return
            }
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
    
    @IBAction func moveToday(_ sender: UIButton) {
        moveToday()
    }
    
    //MARK: - COLLECTION VIEW DELEGATE
    
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
        
        if let monthVC = self.storyboard?.instantiateViewController(withIdentifier: "GSCalendarMonthCollectionViewController") as? GSCalendarMonthCollectionViewController {
            
            monthVC.setinit(month: calendar.months[indexPath.row])
            var frame = collectionView.frame
            frame.origin.x = 0
            frame.origin.y = 0
            monthVC.view.frame = frame
            
            cell.addSubview(monthVC.view)
            monthVC.view.layoutIfNeeded()
            monthVC.collectionView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    //MARK: - SCROLLVIEW DELEGATE
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
