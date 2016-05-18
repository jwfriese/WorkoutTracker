import UIKit

protocol LiftTemplatePickerViewModelDelegate: class {
    func didFinishSelectingLiftDataTemplate(liftDataTemplate: LiftDataTemplate)
}

class LiftTemplatePickerViewModel: NSObject {
    private var _pickerView: UIPickerView?
    
    var dataTemplatePickerView: UIPickerView {
        get {
            if _pickerView == nil {
                _pickerView = UIPickerView()
                _pickerView?.delegate = self
                _pickerView?.dataSource = self
            }
            
            return _pickerView!
        }
    }
    
    weak var delegate: LiftTemplatePickerViewModelDelegate?
}

extension LiftTemplatePickerViewModel: UIPickerViewDelegate {
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

extension LiftTemplatePickerViewModel: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
}
