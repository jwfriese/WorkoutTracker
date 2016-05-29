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
        
        class MockWorkoutListViewController: WorkoutListViewController {
            override func viewDidLoad() { }
        }
        
        fdescribe("StartupViewController") {
            var subject: StartupViewController!
            var mockMigrationAgent: MockMigrationAgent!
            var mockWorkoutListViewController: MockWorkoutListViewController!
            var navigationController: TestNavigationController!
            
            beforeEach {
                let container = Container()
                
                mockMigrationAgent = MockMigrationAgent()
                container.register(MigrationAgent.self) { resolver in
                    return mockMigrationAgent
                }
                
                StartupViewController.registerForInjection(container)
                
                let storyboardMetadata = StartupStoryboardMetadata()
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                mockWorkoutListViewController = MockWorkoutListViewController()
                storyboard.bindViewController(mockWorkoutListViewController, toIdentifier: "WorkoutListViewController")
                
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
                    
                    it("should replace the window's root view controller with the workout list page") {
                        expect(navigationController.topViewController).to(beIdenticalTo(mockWorkoutListViewController))
                    }
                }
            }
        }
    }
}
