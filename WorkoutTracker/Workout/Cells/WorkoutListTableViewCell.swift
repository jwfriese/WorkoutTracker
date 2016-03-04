import UIKit

public class WorkoutListTableViewCell: UITableViewCell {
    public static var name: String = "WorkoutListTableViewCell"
    
    @IBOutlet weak public var contentLabel: UILabel?
    
    public var workout: Workout! {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY, hh:mma"
            let date = NSDate(timeIntervalSince1970: Double(workout.timestamp))
            
            contentLabel?.text = dateFormatter.stringFromDate(date)
        }
    }
}
