import UIKit

class SetEditFormEntryField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.keyboardType = .DecimalPad
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
