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
                    set = LiftSet(withTargetWeight: nil, performedWeight: 235,
                        targetReps: nil, performedReps: 5)
                    subject.addSet(set)
                }
                
                it("appends the set to the lift's list of sets") {
                    expect(subject.sets.count).to(equal(1))
                    expect(subject.sets[0]).to(beIdenticalTo(set))
                }
                
                it("associates this lift with the added set") {
                    expect(subject.sets[0].lift).to(beIdenticalTo(subject))
                }
            }
            
            describe("Identity of a lift") {
                var liftOne: Lift!
                var liftTwo: Lift!
                var liftThree: Lift!
                
                beforeEach {
                    liftOne = Lift(withName: "turtle lift")
                    liftTwo = Lift(withName: "super turtle lift")
                    liftThree = Lift(withName: "turtle lift")
                }
                
                it("is only the same as another lift if the two have the same name") {
                    expect(liftOne.isSame(liftTwo)).to(beFalse())
                    expect(liftOne.isSame(liftThree)).to(beTrue())
                }
            }
        }
    }
}
