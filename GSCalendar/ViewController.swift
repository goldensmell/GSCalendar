import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var overDisplay: UISwitch!
    @IBOutlet weak var useLunarDate: UISwitch!
    @IBOutlet weak var period: UISwitch!
    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var end: UIButton!
    
    @IBOutlet weak var orientScroll: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openCalendar") {
            if let vc = segue.destination as? GSCalendarViewController {
                
                let overDisplayState = getOverDisplayState()
                let useLunarDateState = getUseLunarDate()
                let periodState = getPeriod()
                var startDate:String
                var endDate:String
                if periodState {
                    startDate = (start.titleLabel?.text)!
                    endDate = (end.titleLabel?.text)!
                }
                var scrollDirection = true
                switch orientScroll.selectedSegmentIndex{
                    case 0:
                        scrollDirection = true // 가로
                    case 1:
                        scrollDirection = false // 세로
                    default:
                        break
                }
                
                let model = GSCalendarModel()
                model.initData(BaseDate: nil, FixPeriod: periodState, OverDisplay: overDisplayState, UseLunar: useLunarDateState, ScrollDirection: scrollDirection)
                vc.initCalendar(Calendar: model)
            }
        }
    }
    
    func getOverDisplayState() -> Bool {
        let state = overDisplay.isOn
        
        return state
    }
    
    func getUseLunarDate() -> Bool {
        let state = useLunarDate.isOn
        
        return state
    }
    
    func getPeriod() -> Bool {
        let state = period.isOn
        
        return state
    }

    @IBAction func setStartDate(_ sender: UIButton) {
        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "StartDate", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        
        let datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        datePicker.datePickerMode = .date
        
        alert.view.addSubview(datePicker)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.start.setTitle(datePicker.date.getDefaultString(), for: .normal)
            self.start.setTitle(datePicker.date.getDefaultString(), for: .highlighted)
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        self.parent!.present(alert, animated: true, completion: { })

    }
    @IBAction func setEndDate(_ sender: UIButton) {
        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "EndDate", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        
        let datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        datePicker.datePickerMode = .date
        
        alert.view.addSubview(datePicker)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.end.setTitle(datePicker.date.getDefaultString(), for: .normal)
            self.end.setTitle(datePicker.date.getDefaultString(), for: .highlighted)
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        self.parent!.present(alert, animated: true, completion: { })
    }
    
    private func getFlagsInfo() {
        
    }
}

