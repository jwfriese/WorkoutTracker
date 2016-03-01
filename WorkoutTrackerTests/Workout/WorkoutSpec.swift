import Quick
import Nimble
import WorkoutTracker

class WorkoutSpec: QuickSpec {
    override func spec() {
        describe("Workout") {
            var subject: Workout!
            
            beforeEach {
                subject = Workout()
            }
            
            describe("Adding a new lift") {
                var lift: Lift!
                
                beforeEach {
                    lift = Lift(withName: "turtle press")
                    subject.addLift(lift)
                }
                
                it("appends the lift to the workout's list of lifts") {
                    expect(subject.lifts.count).to(equal(1))
                    expect(subject.lifts[0].name).to(equal("turtle press"))
                }
            }
        }
    }
}
