import Quick
import Nimble
import WorkoutTracker

class WorkoutLiftTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("WorkoutLiftTableViewCell") {
            var subject: WorkoutLiftTableViewCell!
            
            beforeEach {
                let tableView = UITableView()
                tableView.registerNib(UINib(nibName: WorkoutLiftTableViewCell.name, bundle:nil), forCellReuseIdentifier: WorkoutLiftTableViewCell.name)
                subject = tableView.dequeueReusableCellWithIdentifier(WorkoutLiftTableViewCell.name)
                    as! WorkoutLiftTableViewCell
            }
            
            describe("Setting a lift") {
                beforeEach {
                    let lift = Lift(withName: "turtle press")
                    subject.lift = lift
                }
                
                it("sets the lift's name as the content label's text") {
                    expect(subject.contentLabel?.text).to(equal("turtle press"))
                }
            }
        }
    }
}
