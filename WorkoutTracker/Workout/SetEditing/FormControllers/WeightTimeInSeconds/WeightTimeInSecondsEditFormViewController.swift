import UIKit
import Swinject

public class WeightTimeInSecondsEditFormViewController: UIViewController {
    @IBOutlet public weak var weightEntryInputField: UITextField?
    @IBOutlet public weak var timeInSecondsEntryInputField: UITextField?
    
    private var _delegate: SetEditFormDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weightNumber = delegate?.set?.data["weight"] as? Double {
            weightEntryInputField?.text = String(weightNumber)
        }
        
        if let timeNumber = delegate?.set?.data["time(sec)"] as? Int {
            timeInSecondsEntryInputField?.text = String(timeNumber)
        }
    }
    
    @IBAction func onTextFieldChanged() {
        if let delegate = delegate {
            delegate.onFormChanged()
        }
    }
}

extension WeightTimeInSecondsEditFormViewController: Injectable {
    public static func registerForInjection(container: Container) {
        container.register(WeightTimeInSecondsEditFormViewController.self) { resolver in
            return WeightTimeInSecondsEditFormViewController(nibName: "WeightTimeInSecondsEditFormViewController", bundle: nil)
        }
    }
}

extension WeightTimeInSecondsEditFormViewController: LiftSetEditFormController {
    public var form: UIView? {
        get {
            return view
        }
    }
    
    public var enteredLiftData: [String : AnyObject] {
        get {
            var data = [String : AnyObject]()
            if let weight = weightEntryInputField?.text {
                if let castedWeight = Double(weight) {
                    data["weight"] = castedWeight
                }
            }
            
            if let time = timeInSecondsEntryInputField?.text {
                if let castedTime = Int(time) {
                    data["time(sec)"] = castedTime
                }
            }
            
            return data
        }
    }
    
    public var isFormValid: Bool {
        get {
            if let weightText = weightEntryInputField?.text {
                if let timeText = timeInSecondsEntryInputField?.text {
                    let isEitherFieldEmpty = weightText.isEmpty || timeText.isEmpty
                    return !isEitherFieldEmpty
                }
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
        weightEntryInputField?.resignFirstResponder()
        timeInSecondsEntryInputField?.resignFirstResponder()
    }
}
