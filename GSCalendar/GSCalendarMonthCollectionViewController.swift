import UIKit

private let reuseIdentifier = "GSCalendarCollectionViewCell"

class GSCalendarMonthCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var month:GSCalendarMonthModel = GSCalendarMonthModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func setinit(month:GSCalendarMonthModel) {
        
        self.month = month
        
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month.getDateOfMonth()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GSCalendarMonthCollectionViewCell", for: indexPath) as! GSCalendarMonthCollectionViewCell
        // Configure the cell
        
//        cell.backgroundColor = UIColor.green        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.black.cgColor

        let (isThisMonth, day) = month.getDay(indexPath.row)
//
//        cell.isThisMonth = isHidden
        cell.date.text = day
        cell.date.alpha = 1
        
        // 일요일
        if isThisMonth == true {
            if(month.checkSunday(Int(day)!) == true) {
                cell.date.textColor = UIColor.red
            }
            // 토요일
            else if(month.checkSaturday(Int(day)!) == true) {
                cell.date.textColor = UIColor.blue
            }else {
                cell.date.textColor = UIColor.black
            }

            // 오늘 날짜
            if(month.checkCurrentDay(Int(day)!) == true) {
                cell.date.textColor = UIColor.white
                cell.backgroundColor = UIColor.gray
            }
        }
        if isThisMonth == false {
            cell.date.textColor = UIColor.black
            cell.date.alpha = 0.5
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("month - \(indexPath.row)")
    }
    
    
    func setloyoutView(_ frame:CGRect) {
//        let width = frame.width/7 - 10
//        let height: CGFloat = frame.height/7 - 10
//
//        self.collectionViewLayout = CGSize(width: width, height: height)
//
//        self.view.layoutIfNeeded()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width)/7
        let height: CGFloat = self.view.frame.height/7 - 10
        return CGSize(width: width, height: height)
    }
}

class GSCalendarMonthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    
    
}
