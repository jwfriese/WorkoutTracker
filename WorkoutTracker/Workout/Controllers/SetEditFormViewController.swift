import UIKit

public protocol SetEditFormDelegate {
    func setEnteredWithWeight(weight: Double, reps: Int)
}

public class SetEditFormViewController: UIViewController {
    @IBOutlet public weak var formContentView: UIView?
    @IBOutlet public weak var weightEntryInputField: UITextField?
    @IBOutlet public weak var repsEntryInputField: UITextField?
    @IBOutlet public weak var formSubmitButton: UIButton?
    
    public var set: LiftSet?
    public var delegate: SetEditFormDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if set == nil {
            set = LiftSet(withWeight: 0, reps: 0)
            weightEntryInputField?.becomeFirstResponder()
            formSubmitButton?.setTitle("Add", forState: .Normal)
            disableFormSubmitButton()
        } else {
            formSubmitButton?.setTitle("Save", forState: .Normal)
            
            weightEntryInputField?.text = String(set!.weight)
            repsEntryInputField?.text = String(set!.reps)
        }
        
        formContentView?.layer.borderWidth = 2.0
        formContentView?.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    @IBAction public func formSubmitButtonTapped() {
        let weight = Double((weightEntryInputField?.text)!)
        let reps = Int((repsEntryInputField?.text)!)
        delegate?.setEnteredWithWeight(weight!, reps: reps!)
    }
    
    @IBAction public func textFieldEdited() {
        if let weightEntryInputFieldText = weightEntryInputField?.text {
            if let repsEntryInputFieldText = repsEntryInputField?.text {
                if weightEntryInputFieldText.characters.count == 0 ||
                   repsEntryInputFieldText.characters.count == 0 {
                    disableFormSubmitButton()
                } else {
                    enableFormSubmitButton()
                }
            } else {
                disableFormSubmitButton()
            }
        } else {
            disableFormSubmitButton()
        }
    }
    
    private func enableFormSubmitButton() {
        formSubmitButton?.enabled = true
        formSubmitButton?.alpha = 1.0
    }
    
    private func disableFormSubmitButton() {
        formSubmitButton?.enabled = false
        formSubmitButton?.alpha = 0.4
    }
}
