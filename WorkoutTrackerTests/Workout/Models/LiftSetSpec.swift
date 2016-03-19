import Quick
import Nimble
import WorkoutTracker

class LiftSetSpec: QuickSpec {
    override func spec() {
        describe("LiftSet") {
            var subject: LiftSet!
            
            describe("Its initializer") {
                beforeEach {
                    subject = LiftSet(withTargetWeight: 500, performedWeight:515,
                        targetReps: 10, performedReps: 9)
                }
                
                it("sets the target weight of the set") {
                    expect(subject.targetWeight).to(equal(500))
                }
                
                it("sets the performed weight of the set") {
                    expect(subject.performedWeight).to(equal(515))
                }
                
                it("sets the target reps of the set") {
                    expect(subject.targetReps).to(equal(10))
                }
                
                it("sets the performed reps of the set") {
                    expect(subject.performedReps).to(equal(9))
                }
            }
        }
    }
}
