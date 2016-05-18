import UIKit

public protocol LiftEntryFormDelegate {
    func liftEnteredWithName(name: String, dataTemplate: LiftDataTemplate)
}

public class LiftEntryFormViewController: UIViewController {
    @IBOutlet public weak var formContentView: UIView?
    @IBOutlet public weak var nameEntryInputField: UITextField?
    @IBOutlet public weak var createButton: UIButton?
    @IBOutlet public weak var selectView: UIView?
    @IBOutlet public weak var selectDataButton: UIButton?
    @IBOutlet public weak var displaySelectionView: UIView?
    @IBOutlet public weak var displaySelectionLabel: UILabel?
    @IBOutlet public weak var changeSelectionButton: UIButton?
    
    public var delegate: LiftEntryFormDelegate?
    
    var liftTemplatePickerViewModel: LiftTemplatePickerViewModel!
    
    private var selectedDataTemplate: LiftDataTemplate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        formContentView?.layer.borderWidth = 2.0
        formContentView?.layer.borderColor = UIColor.grayColor().CGColor
        
        nameEntryInputField?.becomeFirstResponder()
        disableCreateButton()
        
        selectView?.hidden = false
        displaySelectionView?.hidden = true
        
        liftTemplatePickerViewModel.delegate = self
    }
    
    @IBAction private func selectDataTemplateButtonTapped() {
        view.addSubview(liftTemplatePickerViewModel.dataTemplatePickerView)
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

extension LiftEntryFormViewController: LiftTemplatePickerViewModelDelegate {
    func didFinishSelectingLiftDataTemplate(liftDataTemplate: LiftDataTemplate) {
        selectView?.hidden = true
        displaySelectionView?.hidden = false
        liftTemplatePickerViewModel.dataTemplatePickerView.removeFromSuperview()
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
    }
}
