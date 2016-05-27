import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class StartupViewControllerSpec: QuickSpec {
    override func spec() {
        class MockMigrationAgent: MigrationAgent {
            var didStartMigrationWork: Bool = false
            var givenCompletionHandler: (() -> ())?
            
            override func performMigrationWork(completionHandler completionHandler: (() -> ())?) {
                didStartMigrationWork = true
                givenCompletionHandler = completionHandler
            }
            
            func finishMigrationWork() {
                if let completionHandler = givenCompletionHandler {
                    completionHandler()
                }
            }
        }
        
        class MockWorkoutListStoryboardMetadata: WorkoutListStoryboardMetadata {
            var workoutListInitialController = UINavigationController()
            
            override var initialViewController: UIViewController {
                return workoutListInitialController
            }
        }
        
        describe("StartupViewController") {
            var subject: StartupViewController!
            var mockMigrationAgent: MockMigrationAgent!
            var mockWorkoutListStoryboardMetadata: MockWorkoutListStoryboardMetadata!
            var navigationController: TestNavigationController!
            
            beforeEach {
                mockMigrationAgent = MockMigrationAgent()
                mockWorkoutListStoryboardMetadata = MockWorkoutListStoryboardMetadata()
                
                let storyboardMetadata = StartupStoryboardMetadata()
                let container = Container()
                container.register(MigrationAgent.self) { resolver in
                    return mockMigrationAgent
                }
                
                container.register(WorkoutListStoryboardMetadata.self) { resolver in
                    return mockWorkoutListStoryboardMetadata
                }
                
                StartupViewController.registerForInjection(container)
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("StartupViewController")
                    as! StartupViewController
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
                
                TestAppDelegate.setAsRootViewController(navigationController)
            }
            
            describe("Injection of its dependencies") {
                it("sets its MigrationAgent") {
                    expect(subject.migrationAgent).to(beIdenticalTo(mockMigrationAgent))
                }
                
                it("sets its WorkoutListStoryboardMetadata") {
                    expect(subject.workoutListStoryboardMetadata).to(beIdenticalTo(mockWorkoutListStoryboardMetadata))
                }
            }
            
            describe("After its view has loaded") {
                beforeEach {
                    subject.view
                }
                
                it("starts the migration agent") {
                    expect(mockMigrationAgent.didStartMigrationWork).to(beTrue())
                }
                
                describe("When the migration agent finishes its work") {
                    beforeEach {
                        mockMigrationAgent.finishMigrationWork()
                    }
                    
                    xit("should replace the window's root view controller with the workout list page") {
                        expect(UIApplication.sharedApplication().keyWindow?.rootViewController).toEventually(beIdenticalTo(mockWorkoutListStoryboardMetadata.workoutListInitialController))
                    }
                }
            }
        }
    }
}
