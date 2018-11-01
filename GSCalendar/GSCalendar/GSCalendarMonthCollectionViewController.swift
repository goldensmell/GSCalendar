import UIKit

private let reuseIdentifier = "GSCalendarCollectionViewCell"

class GSCalendarMonthCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var month:GSCalendarMonthModel = GSCalendarMonthModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

       // self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        //self.collectionView.reloadData()
    }
    
    func setinit(month:GSCalendarMonthModel) {
        
        self.month = month
        
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.size.width)/7)
        let height: CGFloat = floor(collectionView.frame.size.height/7)
        return CGSize(width: width, height: height)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month.displayTotalDate
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GSCalendarMonthCollectionViewCell", for: indexPath) as! GSCalendarMonthCollectionViewCell
        // Configure the cell
        
//        cell.backgroundColor = UIColor.green        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.black.cgColor
        
        let index = indexPath.row

        let (isThisMonth, solar, lunar) = month.getDay(index)
        
        cell.setDefaultUI()
        
        cell.date.text = solar
        if let realLunar = lunar {
            cell.lunarDay.text = realLunar
        }else {
            cell.lunarDay.text = ""
        }
        
        if isThisMonth == true {
            
            //오늘
            cell.setTodayUI(month.checkCurrentDay(index))
            
            // 일요일
            if(month.checkSunday(Int(solar)!) == true) {
                cell.date.textColor = UIColor.red
            }
            // 토요일
            else if(month.checkSaturday(Int(solar)!) == true) {
                cell.date.textColor = UIColor.blue
            }
            
        }else {
            cell.date.textColor = UIColor.lightGray
            
            if month.getUseDisplayOverMonth() == false{
                cell.setHiddenUI()
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        //print("didHighlightItemAt - \(indexPath.row)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            //print("shouldSelectItemAt - \(indexPath.row)")
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt - \(indexPath.row)")
    }
}

class GSCalendarMonthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var lunarDay: UILabel!
    
    func setDefaultUI() {
        date.textColor = UIColor.black
        date.isHidden = false
        lunarDay.isHidden = false
    }
    
    func setHiddenUI(){
        date.isHidden = true
        lunarDay.isHidden = true
    }
    
    func setTodayUI(_ isToday:Bool){
        if isToday {
            date.layer.masksToBounds = true //지정 크기를 넘어가는 이미지 자르기
            date.layer.cornerRadius = date.frame.size.width / 2 // 라운드 처리
            date.backgroundColor = UIColor.red
            date.textColor = UIColor.white
        }else {
            date.backgroundColor = UIColor.clear
        }
    }
    
}
