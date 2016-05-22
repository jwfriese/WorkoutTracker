import UIKit

class LiftSetTableViewCell: UITableViewCell {
    static var name: String = "LiftSetTableViewCell"
    
    @IBOutlet weak var columnStackView: UIStackView?
    
    var set: LiftSet?
    
    override func prepareForReuse() {
        if let columnStackView = columnStackView {
            for arrangedSubview in columnStackView.arrangedSubviews {
                columnStackView.removeArrangedSubview(arrangedSubview)
                arrangedSubview.removeFromSuperview()
            }
        }
    }
    
    func configureWithSet(set: LiftSet) {
        self.set = set
        
        var dataStrings = [String]()
        
        switch set.dataTemplate as LiftDataTemplate {
        case .WeightReps:
            dataStrings = pullOutDataStringsForWeightReps(set.data)
        case .HeightReps:
            dataStrings = pullOutDataStringsForHeightReps(set.data)
        case .TimeInSeconds:
            dataStrings = pullOutDataStringsForTimeInSeconds(set.data)
        case .WeightTimeInSeconds:
            dataStrings = pullOutDataStringsForWeightTimeInSeconds(set.data)
        }
        
        for dataString in dataStrings {
            let subview = NSBundle.mainBundle().loadNibNamed("LiftTableViewCellColumnView", owner: nil, options: nil)[0] as? LiftTableViewCellColumnView
            subview?.textLabel?.text = dataString
            columnStackView?.addArrangedSubview(subview!)
        }
    }
    
    private func pullOutDataStringsForWeightReps(data: [String : AnyObject]) -> [String] {
        var dataStrings = [String]()
        
        if let weight = data["weight"] as? Double {
            dataStrings.append(String(weight))
        }
        
        if let reps = data["reps"] as? Int {
            dataStrings.append(String(reps))
        }
        
        return dataStrings
    }
    
    private func pullOutDataStringsForHeightReps(data: [String : AnyObject]) -> [String] {
        var dataStrings = [String]()
        
        if let height = data["height"] as? Double {
            dataStrings.append(String(height))
        }
        
        if let reps = data["reps"] as? Int {
            dataStrings.append(String(reps))
        }
        
        return dataStrings
    }
    
    private func pullOutDataStringsForTimeInSeconds(data: [String : AnyObject]) -> [String] {
        var dataStrings = [String]()
        
        if let time = data["time(sec)"] as? Double {
            dataStrings.append(String(time))
        }
        
        return dataStrings
    }
    
    private func pullOutDataStringsForWeightTimeInSeconds(data: [String : AnyObject]) -> [String] {
        var dataStrings = [String]()
        
        if let weight = data["weight"] as? Double {
            dataStrings.append(String(weight))
        }
        
        if let time = data["time(sec)"] as? Double {
            dataStrings.append(String(time))
        }
        
        return dataStrings
    }
}
