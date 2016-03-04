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
            
            describe("Adding a set to the lift") {
                var set: LiftSet!
                
                beforeEach {
                    set = LiftSet(withWeight: 235, reps: 5)
                    subject.addSet(set)
                }
                
                it("appends the set to the lift's list of sets") {
                    expect(subject.sets.count).to(equal(1))
                    expect(subject.sets[0]).to(beIdenticalTo(set))
                }
            }
        }
    }
}