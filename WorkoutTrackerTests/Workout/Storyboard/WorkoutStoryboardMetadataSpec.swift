import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutStoryboardMetadata") {
            it("has the correct name") {
                expect(WorkoutStoryboardMetadata.name).to(equal("Workout"))
            }
            
            describe("The storyboard created using the metadata") {
                var storyboard: SwinjectStoryboard!
                var container: Container!
                
                beforeEach {
                    container = WorkoutStoryboardMetadata.container
                    storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: container)
                }
                
                describe("The container") {
                    var workoutViewController: WorkoutViewController?
                    
                    beforeEach {
                        workoutViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController") as? WorkoutViewController
                    }
                    
                    describe("Its WorkoutViewController") {
                        it("can be created") {
                            expect(workoutViewController).toNot(beNil())
                        }
                    }
                }
            }
        }
    }
}
