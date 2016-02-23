import UIKit

public class WorkoutListViewModel: NSObject {
    public init(withTimestamper timestamper: Timestamper) {
        self.timestamper = timestamper
    }
    
    public private(set) var timestamper: Timestamper!
    public private(set) var workouts: [WorkoutIdentifier] = []
    
    public func createNewWorkout() {
        workouts.append(WorkoutIdentifier(withTimestamp: timestamper.getTimestamp()))
    }
    
    public func setUpTableView(tableView: UITableView) {
        tableView.registerNib(UINib(nibName: WorkoutListTableViewCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier:WorkoutListTableViewCell.reuseIdentifier)
    }
}

extension WorkoutListViewModel: UITableViewDelegate {
    
}

extension WorkoutListViewModel: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    public func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let workout = workouts[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutListTableViewCell.reuseIdentifier) as! WorkoutListTableViewCell
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY, hh:mma"
            let date = NSDate(timeIntervalSince1970: Double(workout.timestamp))
            
            cell.contentLabel?.text = dateFormatter.stringFromDate(date)
            
            return cell
    }
}
