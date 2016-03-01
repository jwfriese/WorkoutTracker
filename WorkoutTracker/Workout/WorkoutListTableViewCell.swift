import UIKit

public class WorkoutListTableViewCell: UITableViewCell {
    public static var name: String = "WorkoutListTableViewCell"
    
    @IBOutlet weak public var contentLabel: UILabel?
    
    public var workoutListItem: WorkoutListItem! {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY, hh:mma"
            let date = NSDate(timeIntervalSince1970: Double(workoutListItem.timestamp))
            
            contentLabel?.text = dateFormatter.stringFromDate(date)
        }
    }
}
