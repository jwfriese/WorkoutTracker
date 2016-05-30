import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutStoryboardMetadata") {
            var subject: WorkoutStoryboardMetadata!
            
            beforeEach {
                subject = WorkoutStoryboardMetadata()
            }
            
            it("has the correct name") {
                expect(subject.name).to(equal("Workout"))
            }
            
            describe("The initial view controller") {
                var initialViewController: WorkoutViewController?
                
                beforeEach {
                    initialViewController = subject.initialViewController as? WorkoutViewController
                }
                
                it("is a WorkoutViewController") {
                    expect(initialViewController).toNot(beNil())
                }
            }
        }
    }
}
