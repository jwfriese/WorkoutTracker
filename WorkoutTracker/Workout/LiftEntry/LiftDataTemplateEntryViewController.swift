import UIKit

class LiftDataTemplateEntryViewController: UIViewController {
    @IBOutlet weak var dataTemplatePickerView: UIPickerView?
    
    weak var delegate: LiftDataTemplateEntryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataTemplatePickerView?.dataSource = self
        self.dataTemplatePickerView?.delegate = self
    }
}

extension LiftDataTemplateEntryViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row >= LiftDataTemplate.allValues.count {
            return nil
        }
        
        let titles = ["Weight/Reps", "Time(sec)", "Weight/Time(sec)", "Height/Reps"]
        return titles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < LiftDataTemplate.allValues.count {
            delegate?.didFinishSelectingLiftDataTemplate(LiftDataTemplate.allValues[row])
        }
    }
}

extension LiftDataTemplateEntryViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
}
