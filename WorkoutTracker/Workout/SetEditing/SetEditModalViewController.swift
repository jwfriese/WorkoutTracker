 import UIKit
 import Swinject
 
 protocol SetEditDelegate: class {
    var liftDataTemplate: LiftDataTemplate { get }
    var lastSetEntered: LiftSet? { get }
    func setEnteredWithData(data: [String : AnyObject])
    func editCanceled()
 }
 
 class SetEditModalViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var formContainerView: UIView?
    @IBOutlet weak var addPreviousButton: UIButton?
    @IBOutlet weak var formSubmitButton: UIButton?
    @IBOutlet weak var formSubmitButtonAddPreviousConstraint: NSLayoutConstraint?
    @IBOutlet weak var formContainerAddPreviousConstraint: NSLayoutConstraint?
    @IBOutlet weak var formSubmitButtonModalBottomConstraint: NSLayoutConstraint?
    
    var liftSetEditFormControllerFactory: LiftSetEditFormControllerFactory!
    
    var set: LiftSet? = nil
    weak var delegate: SetEditDelegate? = nil
    
    private var formController: LiftSetEditFormController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if set == nil {
            if let delegate = delegate {
                formController = liftSetEditFormControllerFactory.controllerForTemplate(delegate.liftDataTemplate)
            }
            
            formSubmitButton?.setTitle("Add", forState: .Normal)
            disableFormSubmitButton()
        } else {
            formSubmitButton?.setTitle("Save", forState: .Normal)
            
            formController = liftSetEditFormControllerFactory.controllerForTemplate(set!.dataTemplate)
            
            formController?.removeCursorFromFields()
        }
        
        formController?.delegate = self
        
        if let formView = formController?.form {
            formView.frame = (formContainerView?.frame)!
            formView.autoresizingMask = .FlexibleWidth
            formContainerView?.addSubview(formView)
            formView.topAnchor.constraintEqualToAnchor(formContainerView?.topAnchor).active = true
            formView.bottomAnchor.constraintEqualToAnchor(formContainerView?.bottomAnchor).active = true
            formView.leadingAnchor.constraintEqualToAnchor(formContainerView?.leadingAnchor).active = true
            formView.trailingAnchor.constraintEqualToAnchor(formContainerView?.trailingAnchor).active = true
        }
        
        if delegate?.lastSetEntered == nil {
            hideAddPreviousButton()
        }
        
        contentView?.layer.borderWidth = 2.0
        contentView?.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    @IBAction func handleTapOutsideModal() {
        delegate?.editCanceled()
    }
    
    @IBAction func formSubmitButtonTapped() {
        if let formController = formController {
            delegate?.setEnteredWithData(formController.enteredLiftData)
        }
    }
    
    @IBAction func addPreviousButtonTapped() {
        if let lastSet = delegate?.lastSetEntered {
            delegate?.setEnteredWithData(lastSet.data)
        }
    }
    
    private func hideAddPreviousButton() {
        addPreviousButton?.hidden = true
        contentView?.removeConstraint(formSubmitButtonAddPreviousConstraint!)
        contentView?.removeConstraint(formContainerAddPreviousConstraint!)
        formSubmitButton?.topAnchor.constraintEqualToAnchor(formContainerView?.bottomAnchor, constant: 0).active = true
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
 
 extension SetEditModalViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.registerForStoryboard(SetEditModalViewController.self) { resolver, instance in
            instance.liftSetEditFormControllerFactory = resolver.resolve(LiftSetEditFormControllerFactory.self)
        }
    }
 }
 
 extension SetEditModalViewController: SetEditFormDelegate {
    func onFormChanged() {
        if formController != nil && formController!.isFormValid {
            enableFormSubmitButton()
        } else {
            disableFormSubmitButton()
        }
    }
 }
