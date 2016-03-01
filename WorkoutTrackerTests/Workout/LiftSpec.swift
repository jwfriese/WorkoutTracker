import Quick
import Nimble
import WorkoutTracker

class LiftSpec: QuickSpec {
    override func spec() {
        describe("Lift") {
            var subject: Lift!
            
            describe("Its initializer") {
                beforeEach {
                    subject = Lift(withName:"turtle magic")
                }
                
                it("sets the name of the lift") {
                    expect(subject.name).to(equal("turtle magic"))
                }
            }
        }
    }
}
