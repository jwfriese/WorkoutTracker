import UIKit

public protocol LiftEntryFormDelegate {
    func liftEnteredWithName(name: String)
}

public class LiftEntryFormViewController: UIViewController {
    @IBOutlet public weak var formContentView: UIView?
    @IBOutlet public weak var nameEntryInputField: UITextField?
    @IBOutlet public weak var createButton: UIButton?
    
    public var delegate: LiftEntryFormDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        formContentView?.layer.borderWidth = 2.0
        formContentView?.layer.borderColor = UIColor.grayColor().CGColor
        
        nameEntryInputField?.becomeFirstResponder()
        disableCreateButton()
    }
    
    @IBAction public func createButtonTapped() {
        delegate?.liftEnteredWithName((nameEntryInputField?.text)!)
    }
    
    @IBAction public func textFieldEdited() {
        if let nameEntryInputFieldText = nameEntryInputField?.text {
            if nameEntryInputFieldText.characters.count == 0 {
                disableCreateButton()
            } else {
                enableCreateButton()
            }
        } else {
            disableCreateButton()
        }
    }
    
    private func enableCreateButton() {
        createButton?.enabled = true
        createButton?.alpha = 1.0
    }
    
    private func disableCreateButton() {
        createButton?.enabled = false
        createButton?.alpha = 0.4
    }
}
