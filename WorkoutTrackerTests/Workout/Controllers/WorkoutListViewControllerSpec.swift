import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutListViewControllerSpec: QuickSpec {
    class MockTimestamper: Timestamper {
        var timestamp: UInt!
        
        override func getTimestamp() -> UInt {
            if let timestamp = timestamp {
                return timestamp
            }
            
            return 0
        }
    }
    
    class MockWorkoutSaveAgent: WorkoutSaveAgent {
        var savedWorkout: Workout?
        
        init() {
            super.init(withWorkoutSerializer: nil, liftSaveAgent: nil, localStorageWorker: nil)
        }
        
        override func save(workout: Workout) -> String {
            savedWorkout = workout
            return ""
        }
    }
    
    class MockWorkoutLoadAgent: WorkoutLoadAgent {
        init() {
            super.init(withWorkoutDeserializer:nil, localStorageWorker:nil)
        }
        
        override func loadAllWorkouts() -> [Workout] {
            return [
                Workout(withName: "turtle workout one", timestamp: 1000),
                Workout(withName: "turtle workout two", timestamp: 2000),
                Workout(withName: "turtle workout three", timestamp: 3000)
            ]
        }
    }
    
    class MockWorkoutStoryboardMetadata: WorkoutStoryboardMetadata {
        var workoutViewController: WorkoutViewController = WorkoutViewController()
        
        override init() { }
        
        override var container: Container {
            let container = Container()
            
            container.registerForStoryboard(WorkoutViewController.self) { resolver, instance in
                return self.workoutViewController
            }
            
            return container
        }
        
        override var initialViewController: UIViewController {
            return workoutViewController
        }
    }
    
    class MockWorkoutDeleteAgent: WorkoutDeleteAgent {
        var deletedWorkout: Workout?
        
        init() {
            super.init(withLocalStorageWorker: nil)
        }
        
        override func delete(workout: Workout) {
            deletedWorkout = workout
        }
    }
    
    override func spec() {
        describe("WorkoutListViewController") {
            var subject: WorkoutListViewController!
            var mockTimestamper: MockTimestamper!
            var mockWorkoutSaveAgent: MockWorkoutSaveAgent!
            var mockWorkoutLoadAgent: MockWorkoutLoadAgent!
            var mockWorkoutDeleteAgent: MockWorkoutDeleteAgent!
            var mockWorkoutStoryboardMetadata: MockWorkoutStoryboardMetadata!
            
            var navigationController: TestNavigationController!
            
            beforeEach {
                let container = Container()
                
                mockTimestamper = MockTimestamper()
                mockWorkoutSaveAgent = MockWorkoutSaveAgent()
                mockWorkoutLoadAgent = MockWorkoutLoadAgent()
                mockWorkoutDeleteAgent = MockWorkoutDeleteAgent()
                mockWorkoutStoryboardMetadata = MockWorkoutStoryboardMetadata()
                
                container.register(Timestamper.self) { _ in mockTimestamper }
                container.register(WorkoutSaveAgent.self) { _ in mockWorkoutSaveAgent }
                container.register(WorkoutLoadAgent.self) { _ in mockWorkoutLoadAgent }
                container.register(WorkoutDeleteAgent.self) { _ in mockWorkoutDeleteAgent }
                container.register(WorkoutStoryboardMetadata.self) { _ in mockWorkoutStoryboardMetadata }
                
                container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
                    instance.timestamper = resolver.resolve(Timestamper.self)
                    instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
                    instance.workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
                    instance.workoutDeleteAgent = resolver.resolve(WorkoutDeleteAgent.self)
                    instance.workoutStoryboardMetadata = resolver.resolve(WorkoutStoryboardMetadata.self)
                }
                
                let storyboard = SwinjectStoryboard.create(name: "WorkoutList", bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("WorkoutListViewController")
                    as! WorkoutListViewController
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
                
                TestAppDelegate.setAsRootViewController(navigationController)
            }
            
            describe("Once the view has loaded") {
                beforeEach {
                    subject.view
                }
                
                it("should set the page's title") {
                    expect(subject.title).to(equal("All Workouts"))
                }
                
                it("should set itself as its table view's delegate") {
                    let delegate = subject.tableView?.delegate
                    expect(delegate === subject).to(beTrue())
                }
                
                it("should set itself as its table view's data source") {
                    let dataSource = subject.tableView?.delegate
                    expect(dataSource === subject).to(beTrue())
                }
                
                it("registers the WorkoutListTableViewCell with its table view") {
                    let realCell = subject.tableView?.dequeueReusableCellWithIdentifier(WorkoutListTableViewCell.name)
                    expect(realCell).toNot(beNil())
                }
                
                it("loads all the workouts from disk into memory") {
                    expect(subject.workouts.count).to(equal(3))
                    expect(subject.workouts[0].name).to(equal("turtle workout one"))
                    expect(subject.workouts[1].name).to(equal("turtle workout two"))
                    expect(subject.workouts[2].name).to(equal("turtle workout three"))
                }
                
                describe("Tapping the right nav bar item") {
                    beforeEach {
                        let navigationItem = subject.navigationItem
                        let rightNavigationBarButtonItem = navigationItem.rightBarButtonItem!
                        UIApplication.sharedApplication().sendAction(rightNavigationBarButtonItem.action, to: rightNavigationBarButtonItem.target, from: nil, forEvent: nil)
                    }
                    
                    it("adds a new item") {
                        expect(subject.workouts.count).to(equal(4))
                    }
                    
                    it("saves the newly added item") {
                        expect(mockWorkoutSaveAgent.savedWorkout).to(beIdenticalTo(subject.workouts[3]))
                    }
                }
                
                describe("As a table view data source") {
                    beforeEach {
                        mockTimestamper.timestamp = 644569200 // June 05, 1990 12:00AM
                        subject.addWorkoutItem()
                        
                        mockTimestamper.timestamp = 1149490800 // June 05, 2006 12:00AM
                        subject.addWorkoutItem()
                        
                        mockTimestamper.timestamp = 1307257200 // June 05, 2011 12:00AM
                        subject.addWorkoutItem()
                    }
                    
                    it("has a row for each workout") {
                        expect(subject.tableView(subject.tableView!, numberOfRowsInSection: 0)).to(equal(6))
                    }
                    
                    describe("Its cells") {
                        let firstIndexPath = NSIndexPath(forRow: 3, inSection: 0)
                        let secondIndexPath = NSIndexPath(forRow: 4, inSection: 0)
                        let thirdIndexPath = NSIndexPath(forRow: 5, inSection: 0)
                        
                        var firstCell: WorkoutListTableViewCell!
                        var secondCell: WorkoutListTableViewCell!
                        var thirdCell: WorkoutListTableViewCell!
                        
                        beforeEach {
                            firstCell = subject.tableView(subject.tableView!, cellForRowAtIndexPath: firstIndexPath) as! WorkoutListTableViewCell
                            secondCell = subject.tableView(subject.tableView!, cellForRowAtIndexPath: secondIndexPath) as! WorkoutListTableViewCell
                            thirdCell = subject.tableView(subject.tableView!, cellForRowAtIndexPath: thirdIndexPath) as! WorkoutListTableViewCell
                        }
                        
                        it("sets each cell with the correct workout") {
                            expect(firstCell.workout).to(beIdenticalTo(subject.workouts[3]))
                            expect(secondCell.workout).to(beIdenticalTo(subject.workouts[4]))
                            expect(thirdCell.workout).to(beIdenticalTo(subject.workouts[5]))
                        }
                        
                        describe("Selecting a cell") {
                            beforeEach {
                                subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                            }
                            
                            it("should present the page for that workout") {
                                expect(navigationController.topViewController).to(beAnInstanceOf(WorkoutViewController.self))
                                expect(navigationController.topViewController).to(
                                    beIdenticalTo(mockWorkoutStoryboardMetadata.workoutViewController)
                                )
                            }
                            
                            it("sets the selected cell's lift on the presented lift page") {
                                let workoutViewController = navigationController.topViewController as? WorkoutViewController
                                expect(workoutViewController?.workout).to(beIdenticalTo(firstCell.workout))
                            }
                        }
                        
                        describe("Swiping right on a cell and tapping the revealed delete button") {
                            var workoutToDelete: Workout!
                            
                            beforeEach {
                                workoutToDelete = firstCell.workout
                                
                                subject.tableView(subject.tableView!, commitEditingStyle: .Delete,
                                    forRowAtIndexPath: firstIndexPath)
                            }
                            
                            it("deletes the cell") {
                                expect(subject.tableView(subject.tableView!, numberOfRowsInSection: 0)).to(equal(5))
                            }
                            
                            it("removes the associated workout from the list of workouts") {
                                expect(subject.workouts).toNot(contain(workoutToDelete))
                            }
                            
                            it("deletes the workout from disk") {
                                expect(workoutToDelete).to(beIdenticalTo(mockWorkoutDeleteAgent.deletedWorkout))
                            }
                        }
                    }
                }
            }
        }
    }
}
