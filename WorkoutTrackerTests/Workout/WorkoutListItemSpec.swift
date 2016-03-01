import Quick
import Nimble
import WorkoutTracker

class WorkoutListItemSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListItem") {
            var subject: WorkoutListItem!
            
            beforeEach {
                subject = WorkoutListItem(withTimestamp: 2555)
            }
            
            describe("Its initializer") {
                it("sets the timestamp") {
                    expect(subject.timestamp).to(equal(2555))
                }
            }
        }
    }
}
