import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutListStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListStoryboardMetadata") {
            var subject: WorkoutListStoryboardMetadata!
            
            beforeEach {
                subject = WorkoutListStoryboardMetadata()
            }
            
            it("has the correct name") {
                expect(subject.name).to(equal("WorkoutList"))
            }
            
            describe("The initial view controller") {
                var initialViewController: UINavigationController?
                
                beforeEach {
                    initialViewController = subject.initialViewController as? UINavigationController
                }
                
                it("is a UINavigationController") {
                    expect(initialViewController).toNot(beNil())
                }
                
                it("contains a WorkoutListViewController") {
                    expect(initialViewController?.topViewController).to(beAnInstanceOf(WorkoutListViewController.self))
                }
            }
        }
    }
}
