import UIKit

protocol LiftSetEditFormController {
        var form: UIView? { get }
        var enteredLiftData: [String : AnyObject] { get }
        var isFormValid: Bool { get }
        var delegate: SetEditFormDelegate? { get set }

        func removeCursorFromFields()
}
