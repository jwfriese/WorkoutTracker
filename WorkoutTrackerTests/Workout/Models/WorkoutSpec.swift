import Quick
import Nimble
@testable import WorkoutTracker

class WorkoutSpec: QuickSpec {
    override func spec() {
        describe("Workout") {
            var subject: Workout!
            
            beforeEach {
                subject = Workout(withName: "turtle workout", timestamp: 1000)
            }
            
            describe("Its initializer") {
                it("sets the workout's name") {
                    expect(subject.name).to(equal("turtle workout"))
                }
                
                it("sets the workout's timestamp") {
                    expect(subject.timestamp).to(equal(1000))
                }
            }
            
            describe("Adding a new lift") {
                var lift: Lift!
                
                beforeEach {
                    lift = Lift(withName: "turtle press", dataTemplate: .WeightReps)
                    subject.addLift(lift)
                }
                
                it("appends the lift to the workout's list of lifts") {
                    expect(subject.lifts.count).to(equal(1))
                    expect(subject.lifts[0].name).to(equal("turtle press"))
                }
                
                it("associates this workout with the added lift") {
                    expect(subject.lifts[0].workout).to(beIdenticalTo(subject))
                }
            }
            
            describe("Querying for a lift by name") {
                let liftOne = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                let liftTwo = Lift(withName: "turtle press", dataTemplate: .WeightReps)
                
                var resultLift: Lift?
                
                beforeEach {
                    subject.addLift(liftOne)
                    subject.addLift(liftTwo)
                }
                
                context("When a lift with that name exists") {
                    beforeEach {
                        resultLift = subject.liftWithName("turtle press")
                    }
                    
                    it("returns that lift") {
                        expect(resultLift).to(beIdenticalTo(liftTwo))
                    }
                }
                
                context("When a lift with that name does not exist") {
                    beforeEach {
                        resultLift = subject.liftWithName("turtle clean")
                    }
                    
                    it("returns that lift") {
                        expect(resultLift).to(beNil())
                    }
                }
            }
            
            describe("Removing a lift by name"){
                let liftOne = Lift(withName: "turtle lift", dataTemplate: .WeightReps)
                let liftTwo = Lift(withName: "turtle press", dataTemplate: .WeightReps)
                
                beforeEach {
                    subject.addLift(liftOne)
                    subject.addLift(liftTwo)
                }
                
                context("When a lift with the requested name exists") {
                    beforeEach {
                        subject.removeLiftWithName("turtle lift")
                    }
                    
                    it("removes the lift with the requested name") {
                        expect(subject.lifts.count).to(equal(1))
                        expect(subject.lifts).to(contain(liftTwo))
                    }
                }
                
                context("When a lift with the requested name does not exist") {
                    beforeEach {
                        subject.removeLiftWithName("rabbit lift")
                    }
                    
                    it("does nothing to the list of lifts") {
                        expect(subject.lifts.count).to(equal(2))
                        expect(subject.lifts).to(contain(liftOne))
                        expect(subject.lifts).to(contain(liftTwo))
                    }
                }
            }
        }
    }
}
