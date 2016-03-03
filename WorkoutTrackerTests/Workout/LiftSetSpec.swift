import Quick
import Nimble
import WorkoutTracker

class LiftSetSpec: QuickSpec {
    override func spec() {
        describe("LiftSet") {
            var subject: LiftSet!
            
            describe("Its initializer") {
                beforeEach {
                    subject = LiftSet(withWeight: 500, reps: 1000)
                }
                
                it("sets the weight of the set") {
                    expect(subject.weight).to(equal(500))
                }
                
                it("sets the reps of the set") {
                    expect(subject.reps).to(equal(1000))
                }
            }
            
        }
    }
}
