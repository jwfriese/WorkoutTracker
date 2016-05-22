import Quick
import Nimble
@testable import WorkoutTracker
import UIKit

class WorkoutListTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListTableViewCell") {
            var subject: WorkoutListTableViewCell!
            
            beforeEach {
                let tableView = UITableView()
                tableView.registerNib(UINib(nibName: WorkoutListTableViewCell.name, bundle:nil), forCellReuseIdentifier: WorkoutListTableViewCell.name)
                subject = tableView.dequeueReusableCellWithIdentifier(WorkoutListTableViewCell.name)
                    as! WorkoutListTableViewCell
            }
            
            describe("Setting a workout") {
                beforeEach {
                    let workout = Workout(withName: "", timestamp: 644569200) // June 05, 1990 12:00AM
                    subject.workout = workout
                }
                
                it("beautifies the item's timestamp and sets it as the content label's text") {
                    expect(subject.contentLabel?.text).to(equal("06/05/1990, 12:00AM"))
                }
            }
        }
    }
}
