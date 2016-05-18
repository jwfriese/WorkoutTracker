import Quick
import Nimble
@testable import WorkoutTracker

class LiftDataTemplateSpec: QuickSpec {
    override func spec() {
        describe("LiftDataTemplate") {
            describe("The all values static helper") {
                it("returns all the values of the enum") {
                    expect(LiftDataTemplate.allValues.count).to(equal(4))
                    expect(LiftDataTemplate.allValues[0]).to(equal(LiftDataTemplate.WeightReps))
                    expect(LiftDataTemplate.allValues[1]).to(equal(LiftDataTemplate.TimeInSeconds))
                    expect(LiftDataTemplate.allValues[2]).to(equal(LiftDataTemplate.WeightTimeInSeconds))
                    expect(LiftDataTemplate.allValues[3]).to(equal(LiftDataTemplate.HeightReps))
                }
            }
            
            it("has raw representations of all its values") {
                expect(LiftDataTemplate.WeightReps.rawValue).to(equal("Weight/Reps"))
                expect(LiftDataTemplate.TimeInSeconds.rawValue).to(equal("Time(sec)"))
                expect(LiftDataTemplate.WeightTimeInSeconds.rawValue).to(equal("Weight/Time(sec)"))
                expect(LiftDataTemplate.HeightReps.rawValue).to(equal("Height/Reps"))
            }
        }
    }
}
