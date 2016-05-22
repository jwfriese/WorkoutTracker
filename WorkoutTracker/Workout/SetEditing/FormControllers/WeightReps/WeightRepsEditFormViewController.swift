import UIKit
import Swinject

class WeightRepsEditFormViewController: UIViewController {
    @IBOutlet weak var weightEntryInputField: UITextField?
    @IBOutlet weak var repsEntryInputField: UITextField?
    
    private var _delegate: SetEditFormDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weightNumber = delegate?.set?.data["weight"] as? Double {
            weightEntryInputField?.text = String(weightNumber)
        }
        
        if let repsNumber = delegate?.set?.data["reps"] as? Int {
            repsEntryInputField?.text = String(repsNumber)
        }
    }
    
    @IBAction func onTextFieldChanged() {
        if let delegate = delegate {
            delegate.onFormChanged()
        }
    }
}

extension WeightRepsEditFormViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WeightRepsEditFormViewController.self) { resolver in
            return WeightRepsEditFormViewController(nibName: "WeightRepsEditFormViewController", bundle: nil)
        }
    }
}

extension WeightRepsEditFormViewController: LiftSetEditFormController {
    var form: UIView? {
        get {
            return view
        }
    }
    
    var enteredLiftData: [String : AnyObject] {
        get {
            var data = [String : AnyObject]()
            if let weight = weightEntryInputField?.text {
                if let castedWeight = Double(weight) {
                    data["weight"] = castedWeight
                }
            }
            
            if let reps = repsEntryInputField?.text {
                if let castedReps = Int(reps) {
                    data["reps"] = castedReps
                }
            }
            
            return data
        }
    }
    
    var isFormValid: Bool {
        get {
            if let weightText = weightEntryInputField?.text {
                if let repsText = repsEntryInputField?.text {
                    let isEitherFieldEmpty = weightText.isEmpty || repsText.isEmpty
                    return !isEitherFieldEmpty
                }
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
        weightEntryInputField?.resignFirstResponder()
        repsEntryInputField?.resignFirstResponder()
    }
}
