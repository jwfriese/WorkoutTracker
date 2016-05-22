import UIKit
import Swinject

class TimeInSecondsEditFormViewController: UIViewController {
    @IBOutlet weak var timeInSecondsEntryInputField: UITextField?
    
    private var _delegate: SetEditFormDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let timeNumber = delegate?.set?.data["time(sec)"] as? Double {
            timeInSecondsEntryInputField?.text = String(timeNumber)
        }
    }
    
    @IBAction func onTextFieldChanged() {
        if let delegate = delegate {
            delegate.onFormChanged()
        }
    }
}

extension TimeInSecondsEditFormViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.register(TimeInSecondsEditFormViewController.self) { resolver in
            return TimeInSecondsEditFormViewController(nibName: "TimeInSecondsEditFormViewController", bundle: nil)
        }
    }
}

extension TimeInSecondsEditFormViewController: LiftSetEditFormController {
    var form: UIView? {
        get {
            return view
        }
    }
    
    var enteredLiftData: [String : AnyObject] {
        get {
            var data = [String : AnyObject]()
            if let time = timeInSecondsEntryInputField?.text {
                if let castedTime = Double(time) {
                    data["time(sec)"] = castedTime
                }
            }
            
            return data
        }
    }
    
    var isFormValid: Bool {
        get {
            if let timeText = timeInSecondsEntryInputField?.text {
                return !timeText.isEmpty
            }
            
            return false
        }
    }
    
    var delegate: SetEditFormDelegate? {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
        }
    }
    
    func removeCursorFromFields() {
        timeInSecondsEntryInputField?.resignFirstResponder()
    }
}
