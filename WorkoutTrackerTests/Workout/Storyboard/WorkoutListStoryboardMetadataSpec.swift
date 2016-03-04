import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutListStoryboardMetadataSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListStoryboardMetadata") {
            it("has the correct name") {
                expect(WorkoutListStoryboardMetadata.name).to(equal("WorkoutList"))
            }
            
            describe("The storyboard created using the metadata") {
                var storyboard: SwinjectStoryboard!
                var container: Container!
                
                beforeEach {
                    container = WorkoutListStoryboardMetadata.container
                    storyboard = SwinjectStoryboard.create(name: WorkoutListStoryboardMetadata.name, bundle: nil, container: container)
                }
                
                describe("The container") {
                    var timestamper: Timestamper?
                    var workoutListViewController: WorkoutListViewController?
                    
                    beforeEach {
                        timestamper = container.resolve(Timestamper.self)
                        workoutListViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutListViewController") as? WorkoutListViewController
                    }
                    
                    it("can produce a Timestamper") {
                        expect(timestamper).toNot(beNil())
                    }
                    
                    describe("Its WorkoutListViewController") {
                        it("can be created") {
                            expect(workoutListViewController).toNot(beNil())
                        }
                        
                        it("is created with a Timestamper") {
                            expect(workoutListViewController?.timestamper).toNot(beNil())
                        }
                    }
                }
            }
        }
    }
}
