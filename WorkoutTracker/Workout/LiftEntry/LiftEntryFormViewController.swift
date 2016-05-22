import UIKit

protocol LiftEntryFormDelegate {
    func liftEnteredWithName(name: String, dataTemplate: LiftDataTemplate)
}

class LiftEntryFormViewController: UIViewController {
    @IBOutlet weak var formContentView: UIView?
    @IBOutlet weak var nameEntryInputField: UITextField?
    @IBOutlet weak var createButton: UIButton?
    @IBOutlet weak var selectView: UIView?
    @IBOutlet weak var selectDataButton: UIButton?
    @IBOutlet weak var displaySelectionView: UIView?
    @IBOutlet weak var displaySelectionLabel: UILabel?
    @IBOutlet weak var changeSelectionButton: UIButton?
    
    var delegate: LiftEntryFormDelegate?
    
    private var selectedDataTemplate: LiftDataTemplate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formContentView?.layer.borderWidth = 2.0
        formContentView?.layer.borderColor = UIColor.grayColor().CGColor
        
        nameEntryInputField?.becomeFirstResponder()
        disableCreateButton()
        
        selectView?.hidden = false
        displaySelectionView?.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dataTemplateEntryViewController = segue.destinationViewController as? LiftDataTemplateEntryViewController {
            
            dataTemplateEntryViewController.delegate = self
        }
    }
    
    @IBAction private func selectDataTemplateButtonTapped() {
        self.performSegueWithIdentifier("PresentLiftDataTemplateEntry", sender: nil)
    }
    
    @IBAction private func changeDataTemplateButtonTapped() {
        selectDataTemplateButtonTapped()
    }
    
    @IBAction private func createButtonTapped() {
        if let liftName = nameEntryInputField?.text {
            if let dataTemplate = selectedDataTemplate {
                delegate?.liftEnteredWithName(liftName, dataTemplate: dataTemplate)
            }
        }
    }
    
    @IBAction private func textFieldEdited() {
        updateCreateButtonAvailability()
    }
    
    private func updateCreateButtonAvailability() {
        if selectedDataTemplate != nil {
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

extension LiftEntryFormViewController: LiftDataTemplateEntryDelegate {
    func didFinishSelectingLiftDataTemplate(liftDataTemplate: LiftDataTemplate) {
        selectView?.hidden = true
        displaySelectionView?.hidden = false
        selectedDataTemplate = liftDataTemplate
        updateCreateButtonAvailability()
        
        switch (liftDataTemplate) {
        case .WeightReps:
            displaySelectionLabel?.text = "Weight/Reps"
        case .TimeInSeconds:
            displaySelectionLabel?.text = "Time(sec)"
        case .WeightTimeInSeconds:
            displaySelectionLabel?.text = "Weight/Time(sec)"
        case .HeightReps:
            displaySelectionLabel?.text = "Height/Reps"
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
