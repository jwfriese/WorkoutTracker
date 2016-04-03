import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutViewControllerSpec: QuickSpec {
    override func spec() {
        
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
        
        class MockLiftCreator: LiftCreator {
            init() {
                super.init(withLiftHistoryIndexLoader: nil, workoutLoadAgent: nil)
            }
            
            override private func createWithName(name: String) -> Lift {
                return Lift(withName: name)
            }
        }
        
        describe("WorkoutViewController") {
            var subject: WorkoutViewController!
            var mockWorkoutSaveAgent: MockWorkoutSaveAgent!
            var mockLiftCreator: MockLiftCreator!
            var navigationController: TestNavigationController!
            
            beforeEach {
                mockWorkoutSaveAgent = MockWorkoutSaveAgent()
                mockLiftCreator = MockLiftCreator()
                
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let container = storyboardMetadata.container
                container.register(WorkoutSaveAgent.self) { resolver in
                    return mockWorkoutSaveAgent
                }
                
                container.register(LiftCreator.self) { resolver in
                    return mockLiftCreator
                }
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController")
                    as! WorkoutViewController
                
                subject.workout = Workout(withName: "turtle workout", timestamp: 1000)
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
                
                TestAppDelegate.setAsRootViewController(navigationController)
            }
            
            describe("After loading the view") {
                beforeEach {
                    subject.view
                }
                
                it("should set its title") {
                    expect(subject.title).to(equal("Workout"))
                }
                
                it("should have added itself as the table view's delegate") {
                    let delegate = subject.tableView?.delegate
                    expect(delegate === subject).to(beTrue())
                }
                
                it("should have added itself as the table view's data source") {
                    let delegate = subject.tableView?.dataSource
                    expect(delegate === subject).to(beTrue())
                }
                
                describe("Tapping the right nav bar item") {
                    beforeEach {
                        let navigationItem = subject.navigationItem
                        let rightNavigationBarButtonItem = navigationItem.rightBarButtonItem!
                        UIApplication.sharedApplication().sendAction(rightNavigationBarButtonItem.action, to: rightNavigationBarButtonItem.target, from: nil, forEvent: nil)
                    }
                    
                    it("presents a modal allowing the user to enter lift information") {
                        let modalLiftEntryForm = subject.presentedViewController as? LiftEntryFormViewController
                        
                        expect(modalLiftEntryForm).toNot(beNil())
                        expect(modalLiftEntryForm?.delegate as? WorkoutViewController).to(beIdenticalTo(subject))
                    }
                    
                    describe("When the lift entry form modal finishes") {
                        beforeEach {
                            subject.liftEnteredWithName("turtle lift")
                            TestAppDelegate.layoutWindow()
                        }
                        
                        it("adds a new lift with the given name") {
                            expect(subject.workout.lifts.count).to(equal(1))
                            expect(subject.workout.lifts.first?.name).to(equal("turtle lift"))
                        }
                        
                        it("dismisses the lift entry form modal") {
                            expect(subject.presentedViewController).toEventually(beNil(), timeout:10.0)
                        }
                        
                        it("saves the workout with the new lift on it") {
                            let savedWorkout = mockWorkoutSaveAgent.savedWorkout
                            expect(savedWorkout).toNot(beNil())
                            expect(savedWorkout?.lifts.first?.name).to(equal(subject.workout.lifts.first?.name))
                        }
                        
                        it("reloads the table view's data") {
                            expect(subject.tableView?.dequeueReusableCellWithIdentifier(WorkoutLiftTableViewCell.name, forIndexPath: NSIndexPath(forRow: 0, inSection: 0))).toNot(throwError())
                        }
                    }
                }
                
                describe("Its data table") {
                    beforeEach {
                        subject.workout.addLift(Lift(withName: "turtle press"))
                        subject.workout.addLift(Lift(withName: "turtle squat"))
                        subject.workout.addLift(Lift(withName: "turtle deadlift"))
                        subject.tableView?.reloadData()
                    }
                    
                    it("has one section") {
                        expect(subject.numberOfSectionsInTableView(subject.tableView!)).to(equal(1))
                    }
                    
                    it("has a number of rows equal to the number of lifts in its workout model") {
                        expect(subject.tableView(subject.tableView!, numberOfRowsInSection: 0)).to(equal(3))
                    }
                    
                    describe("The cells") {
                        let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                        let secondIndexPath = NSIndexPath(forRow: 1, inSection: 0)
                        let thirdIndexPath = NSIndexPath(forRow: 2, inSection: 0)
                        
                        var firstCell: WorkoutLiftTableViewCell!
                        var secondCell: WorkoutLiftTableViewCell!
                        var thirdCell: WorkoutLiftTableViewCell!
                        
                        beforeEach {
                            firstCell = subject.tableView(subject.tableView!,
                                cellForRowAtIndexPath: firstIndexPath) as! WorkoutLiftTableViewCell
                            secondCell = subject.tableView(subject.tableView!,
                                cellForRowAtIndexPath: secondIndexPath) as! WorkoutLiftTableViewCell
                            thirdCell = subject.tableView(subject.tableView!,
                                cellForRowAtIndexPath: thirdIndexPath) as! WorkoutLiftTableViewCell
                        }
                        
                        it("use the lifts as models") {
                            expect(firstCell.lift).to(beIdenticalTo(subject.workout.lifts[0]))
                            expect(secondCell.lift).to(beIdenticalTo(subject.workout.lifts[1]))
                            expect(thirdCell.lift).to(beIdenticalTo(subject.workout.lifts[2]))
                        }
                        
                        describe("Selecting a cell") {
                            beforeEach {
                                subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                            }
                            
                            it("presents the page for that lift") {
                                expect(navigationController.topViewController).to(beAnInstanceOf(LiftViewController.self))
                            }
                            
                            it("sets the selected cell's lift on the presented lift page") {
                                let liftViewController = navigationController.topViewController as? LiftViewController
                                expect(liftViewController?.lift).to(beIdenticalTo(firstCell.lift))
                            }
                        }
                    }
                }
            }
        }
    }
}
