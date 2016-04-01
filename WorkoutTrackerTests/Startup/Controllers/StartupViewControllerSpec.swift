import Quick
import Nimble
import Swinject
import WorkoutTracker

class StartupViewControllerSpec: QuickSpec {
    override func spec() {
        class MockMigrationAgent: MigrationAgent {
            var didStartMigrationWork: Bool = false
            var givenCompletionHandler: (() -> ())?
            
            init() {
                super.init(withLiftHistoryIndexBuilder: LiftHistoryIndexBuilder(),
                    workoutLoadAgent:WorkoutLoadAgent(withWorkoutDeserializer: nil, localStorageWorker: nil),
                    localStorageWorker: LocalStorageWorker())
            }
            
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
        
        class MockLiftHistoryIndexBuilder: LiftHistoryIndexBuilder {
            
        }
        
        class MockWorkoutListStoryboardMetadata: WorkoutListStoryboardMetadata {
            var workoutListViewController = WorkoutListViewController()
            
            override var initialViewController: UIViewController {
                return workoutListViewController
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
                let container = storyboardMetadata.container
                container.register(MigrationAgent.self) { resolver in
                    return mockMigrationAgent
                }
                
                container.register(WorkoutListStoryboardMetadata.self) { resolver in
                    return mockWorkoutListStoryboardMetadata
                }
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("StartupViewController")
                    as! StartupViewController
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
                
                TestAppDelegate.setAsRootViewController(navigationController)
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
                    
                    it("should present the workout list page") {
                        expect(navigationController.topViewController).to(
                            beIdenticalTo(mockWorkoutListStoryboardMetadata.workoutListViewController)
                        )
                    }
                }
            }
        }
    }
}
