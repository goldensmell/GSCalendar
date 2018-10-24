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

        let (isThisMonth, solar, lunar) = month.getDay(indexPath.row)
        
//
//        cell.isThisMonth = isHidden
        cell.date.text = solar
        if let realLunar = lunar {
            cell.lunarDay.text = realLunar
        }else {
            cell.lunarDay.text = ""
        }
        cell.date.alpha = 1
        cell.lunarDay.alpha = 1
        
        // 일요일
        if isThisMonth == true {
            if(month.checkSunday(Int(solar)!) == true) {
                cell.date.textColor = UIColor.red
            }
            // 토요일
            else if(month.checkSaturday(Int(solar)!) == true) {
                cell.date.textColor = UIColor.blue
            }else {
                cell.date.textColor = UIColor.black
            }

            //TODO: 오늘 날짜
//            if(month.checkCurrentDay(Int(day)!) == true) {
//                cell.date.textColor = UIColor.white
//                cell.backgroundColor = UIColor.gray
//            }
        }
        if isThisMonth == false {
            cell.date.textColor = UIColor.black
            cell.date.alpha = 0.5
            cell.lunarDay.alpha = 0.5
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
        //print("didSelectItemAt - \(indexPath.row)")
    }
}

class GSCalendarMonthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var lunarDay: UILabel!
    
}
