import UIKit

public protocol SetEditFormDelegate {
    func setEnteredWithWeight(weight: Double, reps: Int)
}

public class SetEditFormViewController: UIViewController {
    @IBOutlet public weak var formContentView: UIView?
    @IBOutlet public weak var weightEntryInputField: UITextField?
    @IBOutlet public weak var repsEntryInputField: UITextField?
    @IBOutlet public weak var addButton: UIButton?
    
    public var delegate: SetEditFormDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        formContentView?.layer.borderWidth = 2.0
        formContentView?.layer.borderColor = UIColor.grayColor().CGColor
        
        weightEntryInputField?.becomeFirstResponder()
        disableAddButton()
    }
    
    @IBAction public func addButtonTapped() {
        let weight = Double((weightEntryInputField?.text)!)
        let reps = Int((repsEntryInputField?.text)!)
        delegate?.setEnteredWithWeight(weight!, reps: reps!)
    }
    
    @IBAction public func textFieldEdited() {
        if let weightEntryInputFieldText = weightEntryInputField?.text {
            if let repsEntryInputFieldText = repsEntryInputField?.text {
                if weightEntryInputFieldText.characters.count == 0 ||
                   repsEntryInputFieldText.characters.count == 0 {
                    disableAddButton()
                } else {
                    enableAddButton()
                }
            } else {
                disableAddButton()
            }
        } else {
            disableAddButton()
        }
    }
    
    private func enableAddButton() {
        addButton?.enabled = true
        addButton?.alpha = 1.0
    }
    
    private func disableAddButton() {
        addButton?.enabled = false
        addButton?.alpha = 0.4
    }
}
