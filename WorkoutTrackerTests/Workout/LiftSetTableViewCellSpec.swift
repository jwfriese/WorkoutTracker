import Quick
import Nimble
import WorkoutTracker

class LiftSetTableViewCellSpec: QuickSpec {
    override func spec() {
        describe("LiftSetTableViewCell") {
            var subject: LiftSetTableViewCell!
            
            beforeEach {
                let tableView = UITableView()
                tableView.registerNib(UINib(nibName: LiftSetTableViewCell.name, bundle:nil), forCellReuseIdentifier: LiftSetTableViewCell.name)
                subject = tableView.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name)
                    as! LiftSetTableViewCell
            }
            
            describe("Configuring with a set") {
                beforeEach {
                    let set = LiftSet(withWeight: 400, reps: 15)
                    subject.configureWithSet(set, setNumber: 2)
                }
                
                it("sets the given set number as the set number label's text") {
                    expect(subject.setNumberLabel?.text).to(equal("2"))
                }
                
                it("sets the set's weight as the weight label's text") {
                    expect(subject.weightLabel?.text).to(equal("400.0"))
                }
                
                it("sets the set's reps as the reps label's text") {
                    expect(subject.repsLabel?.text).to(equal("15"))
                }
            }
        }
    }
}
