import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class StartupStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("StartupStoryboardMetadata") {
            var subject: StartupStoryboardMetadata!
            
            beforeEach {
                subject = StartupStoryboardMetadata()
            }
            
            it("has the correct name") {
                expect(subject.name).to(equal("Startup"))
            }
            
            describe("The initial view controller") {
                var initialViewController: StartupViewController?
                
                beforeEach {
                    initialViewController = subject.initialViewController as? StartupViewController
                }
                
                it("is a StartupViewController") {
                    expect(initialViewController).toNot(beNil())
                }
            }
        }
    }
}
