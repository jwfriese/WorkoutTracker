import Quick
import Nimble
import WorkoutTracker

class WorkoutIdentifierSpec: QuickSpec {
    override func spec() {
        describe("WorkoutIdentifier") {
            var subject: WorkoutIdentifier!
            
            beforeEach {
                subject = WorkoutIdentifier(withTimestamp: 2555)
            }
            
            describe("Its initializer") {
                it("sets the timestamp") {
                    expect(subject.timestamp).to(equal(2555))
                }
            }
        }
    }
}
