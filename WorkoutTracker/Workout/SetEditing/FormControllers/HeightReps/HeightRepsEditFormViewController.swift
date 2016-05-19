import UIKit
import Swinject

public class HeightRepsEditFormViewController: UIViewController {
    @IBOutlet public weak var heightEntryInputField: UITextField?
    @IBOutlet public weak var repsEntryInputField: UITextField?
    
    private var _delegate: SetEditFormDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let heightNumber = delegate?.set?.data["height"] as? Double {
            heightEntryInputField?.text = String(heightNumber)
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

extension HeightRepsEditFormViewController: Injectable {
    public static func registerForInjection(container: Container) {
        container.register(HeightRepsEditFormViewController.self) { resolver in
            return HeightRepsEditFormViewController(nibName: "HeightRepsEditFormViewController", bundle: nil)
        }
    }
}

extension HeightRepsEditFormViewController: LiftSetEditFormController {
    public var form: UIView? {
        get {
            return view
        }
    }
    
    public var enteredLiftData: [String : AnyObject] {
        get {
            var data = [String : AnyObject]()
            if let height = heightEntryInputField?.text {
                if let castedHeight = Double(height) {
                    data["height"] = castedHeight
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
    
    public var isFormValid: Bool {
        get {
            if let heightText = heightEntryInputField?.text {
                if let repsText = repsEntryInputField?.text {
                    let isEitherFieldEmpty = heightText.isEmpty || repsText.isEmpty
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
        heightEntryInputField?.resignFirstResponder()
        repsEntryInputField?.resignFirstResponder()
    }
}
