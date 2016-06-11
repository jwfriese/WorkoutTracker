import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockWorkoutSaveAgent: WorkoutSaveAgent {
            var savedWorkout: Workout?
            
            override func save(workout: Workout) -> String {
                savedWorkout = workout
                return ""
            }
        }
        
        class MockLiftCreator: LiftCreator {
            override private func createWithName(name: String, dataTemplate: LiftDataTemplate) -> Lift {
                return Lift(withName: name, dataTemplate: dataTemplate)
            }
        }
        
        class MockLiftDeleteAgent: LiftDeleteAgent {
            var deletedLift: Lift?
            
            override func delete(lift: Lift) {
                deletedLift = lift
            }
        }
        
        describe("WorkoutViewController") {
            var subject: WorkoutViewController!
            var mockWorkoutSaveAgent: MockWorkoutSaveAgent!
            var mockLiftCreator: MockLiftCreator!
            var mockLiftDeleteAgent: MockLiftDeleteAgent!
            var navigationController: TestNavigationController!
            
            beforeEach {
                let container = Container()
                
                mockWorkoutSaveAgent = MockWorkoutSaveAgent()
                container.register(WorkoutSaveAgent.self) { _ in return mockWorkoutSaveAgent }
                
                mockLiftCreator = MockLiftCreator()
                container.register(LiftCreator.self) { _ in return mockLiftCreator }
                
                mockLiftDeleteAgent = MockLiftDeleteAgent()
                container.register(LiftDeleteAgent.self) { _ in return mockLiftDeleteAgent }
                
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                WorkoutViewController.registerForInjection(container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController")
                    as! WorkoutViewController
                
                subject.workout = Workout(withName: "turtle workout", timestamp: 1000)
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
                
                TestAppDelegate.setAsRootViewController(navigationController)
            }
            
            describe("Its injection") {
                it("sets its WorkoutSaveAgent") {
                    expect(subject.workoutSaveAgent).to(beIdenticalTo(mockWorkoutSaveAgent))
                }
                
                it("sets its LiftCreator") {
                    expect(subject.liftCreator).to(beIdenticalTo(mockLiftCreator))
                }
                
                it("sets its LiftDeleteAgent") {
                    expect(subject.liftDeleteAgent).to(beIdenticalTo(mockLiftDeleteAgent))
                }
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
                            subject.liftEnteredWithName("turtle lift", dataTemplate: .TimeInSeconds)
                            TestAppDelegate.layoutWindow()
                        }
                        
                        it("adds a new lift with the given name and data template") {
                            expect(subject.workout.lifts.count).to(equal(1))
                            expect(subject.workout.lifts.first?.name).to(equal("turtle lift"))
                            expect(subject.workout.lifts.first?.dataTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                        }
                        
                        it("dismisses the lift entry form modal") {
                            expect(subject.presentedViewController).to(beNil())
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
                    let firstLift = Lift(withName: "turtle press", dataTemplate: .WeightReps)
                    let secondLift = Lift(withName: "turtle squat", dataTemplate: .WeightReps)
                    let thirdLift = Lift(withName: "turtle deadlift", dataTemplate: .WeightReps)
                    
                    beforeEach {
                        subject.workout.addLift(firstLift)
                        subject.workout.addLift(secondLift)
                        subject.workout.addLift(thirdLift)
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
                        
                        describe("Swiping right on a cell and tapping the revealed delete button") {
                            var liftToDelete: Lift!
                            
                            beforeEach {
                                liftToDelete = firstCell.lift
                                
                                subject.tableView(subject.tableView!, commitEditingStyle: .Delete,
                                    forRowAtIndexPath: firstIndexPath)
                            }
                            
                            it("deletes the cell") {
                                expect(subject.tableView(subject.tableView!, numberOfRowsInSection: 0)).to(equal(2))
                            }
                            
                            it("removes the associated workout from the list of workouts") {
                                expect(subject.workout.lifts).toNot(contain(liftToDelete))
                            }
                            
                            it("deletes the lift from disk") {
                                expect(liftToDelete).to(beIdenticalTo(mockLiftDeleteAgent.deletedLift))
                            }
                            
                            it("saves the workout with the updated lift information") {
                                let savedWorkout = mockWorkoutSaveAgent.savedWorkout
                                expect(savedWorkout).toNot(beNil())
                                expect(savedWorkout?.lifts[0]).to(beIdenticalTo(secondLift))
                                expect(savedWorkout?.lifts[1]).to(beIdenticalTo(thirdLift))
                            }
                        }
                    }
                }
            }
        }
    }
}
