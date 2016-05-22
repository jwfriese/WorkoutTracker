import UIKit
import Swinject

public class TimeInSecondsEditFormViewController: UIViewController {
    @IBOutlet public weak var timeInSecondsEntryInputField: UITextField?
    
    private var _delegate: SetEditFormDelegate?
    
    public override func viewDidLoad() {
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
    public static func registerForInjection(container: Container) {
        container.register(TimeInSecondsEditFormViewController.self) { resolver in
            return TimeInSecondsEditFormViewController(nibName: "TimeInSecondsEditFormViewController", bundle: nil)
        }
    }
}

extension TimeInSecondsEditFormViewController: LiftSetEditFormController {
    public var form: UIView? {
        get {
            return view
        }
    }
    
    public var enteredLiftData: [String : AnyObject] {
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
    
    public var isFormValid: Bool {
        get {
            if let timeText = timeInSecondsEntryInputField?.text {
                return !timeText.isEmpty
            }
            
            return false
        }
    }
    
    public var delegate: SetEditFormDelegate? {
        get {
            return _delegate
        }
        
        set {
            _delegate = newValue
        }
    }
    
    public func removeCursorFromFields() {
        timeInSecondsEntryInputField?.resignFirstResponder()
    }
}
