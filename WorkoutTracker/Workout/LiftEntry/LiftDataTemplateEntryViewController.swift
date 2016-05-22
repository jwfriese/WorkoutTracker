import UIKit

public class LiftDataTemplateEntryViewController: UIViewController {
    @IBOutlet public weak var dataTemplatePickerView: UIPickerView?
    
    public weak var delegate: LiftDataTemplateEntryDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.dataTemplatePickerView?.dataSource = self
        self.dataTemplatePickerView?.delegate = self
    }
}

extension LiftDataTemplateEntryViewController: UIPickerViewDelegate {
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row >= LiftDataTemplate.allValues.count {
            return nil
        }
        
        let titles = ["Weight/Reps", "Time(sec)", "Weight/Time(sec)", "Height/Reps"]
        return titles[row]
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < LiftDataTemplate.allValues.count {
            delegate?.didFinishSelectingLiftDataTemplate(LiftDataTemplate.allValues[row])
        }
    }
}

extension LiftDataTemplateEntryViewController: UIPickerViewDataSource {
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
}
