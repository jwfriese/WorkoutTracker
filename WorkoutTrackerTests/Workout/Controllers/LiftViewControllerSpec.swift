import Quick
import Nimble
import Fleet
import Swinject
@testable import WorkoutTracker

class LiftViewControllerSpec: QuickSpec {
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
        
        class MockLiftTableHeaderViewProvider: LiftTableHeaderViewProvider {
            var providedView = UIStackView()
            var givenLift: Lift?
            
            override func provideForLift(lift: Lift) -> UIStackView {
                givenLift = lift
                return providedView
            }
        }
        
        describe("LiftViewController") {
            var subject: LiftViewController!
            var mockWorkoutSaveAgent: MockWorkoutSaveAgent!
            var mockLiftTableHeaderViewProvider: MockLiftTableHeaderViewProvider!
            var navigationController: TestNavigationController!
            var lift: Lift!
            
            beforeEach {
                mockWorkoutSaveAgent = MockWorkoutSaveAgent()
                mockLiftTableHeaderViewProvider = MockLiftTableHeaderViewProvider()
                
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let container = storyboardMetadata.container
                container.register(WorkoutSaveAgent.self) { resolver in
                    return mockWorkoutSaveAgent
                }
                
                container.register(LiftTableHeaderViewProvider.self) { resolver in
                    return mockLiftTableHeaderViewProvider
                }
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("LiftViewController")
                    as! LiftViewController
                
                lift = Lift(withName: "turtle deadlift", dataTemplate: .TimeInSeconds)
                lift.workout = Workout(withName: "turtle workout", timestamp: 1000)
                subject.lift = lift
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
            }
            
            describe("After the view has loaded") {
                sharedExamples("The view controller's loading behavior in all contexts") {
                    it("should have set its title") {
                        expect(subject.title).to(equal("turtle deadlift"))
                    }
                    
                    it("should have set itself as its table view's delegate") {
                        let delegate = subject.tableView?.delegate
                        expect(delegate === subject).to(beTrue())
                    }
                    
                    it("should have set itself as its table view's data source") {
                        let delegate = subject.tableView?.dataSource
                        expect(delegate === subject).to(beTrue())
                    }
                }
                
                context("When the view controller is readonly") {
                    var rightNavBarButton: UIBarButtonItem?
                    
                    beforeEach {
                        subject.isReadonly = true
                        
                        TestAppDelegate.setAsRootViewController(navigationController)
                        
                        let navigationItem = subject.navigationItem
                        rightNavBarButton = navigationItem.rightBarButtonItem
                    }
                    
                    itBehavesLike("The view controller's loading behavior in all contexts")
                    
                    it("does not have a right nav bar button") {
                        expect(rightNavBarButton).to(beNil())
                    }
                    
                    it("does not have the button to add a set") {
                        expect(subject.addLiftButton?.hidden).to(beTrue())
                        expect(subject.addLiftButton?.alpha).to(beCloseTo(0.0))
                    }
                    
                    describe("Selecting a cell on the data table") {
                        var setEditForm: SetEditModalViewController?
                        
                        beforeEach {
                            let set = LiftSet(withDataTemplate: .WeightReps, data: ["weight": 100, "reps": 10])
                            subject.lift.addSet(set)
                            subject.tableView?.reloadData()
                            
                            let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                            subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                            setEditForm = subject.presentedViewController as? SetEditModalViewController
                        }
                        
                        it("does not present the set edit modal") {
                            expect(setEditForm).to(beNil())
                        }
                    }
                }
                
                context("When the view controller is not readonly") {
                    beforeEach {
                        subject.isReadonly = false
                        
                        TestAppDelegate.setAsRootViewController(navigationController)
                    }
                    
                    itBehavesLike("The view controller's loading behavior in all contexts")
                    
                    describe("Tapping the right nav bar item") {
                        func action() {
                            let navigationItem = subject.navigationItem
                            let rightNavigationBarButtonItem = navigationItem.rightBarButtonItem!
                            UIApplication.sharedApplication().sendAction(rightNavigationBarButtonItem.action, to: rightNavigationBarButtonItem.target, from: nil, forEvent: nil)
                        }
                        
                        context("When there is no previous instance of this lift") {
                            beforeEach {
                                lift.previousInstance = nil
                                action()
                            }
                            
                            it("leaves the nav stack untouched") {
                                expect(navigationController.topViewController).to(beIdenticalTo(subject))
                            }
                        }
                        
                        context("When there is a previous instance of this lift") {
                            var previousLift: Lift!
                            var liftViewController: LiftViewController?
                            
                            beforeEach {
                                previousLift = Lift(withName: lift.name, dataTemplate: .TimeInSeconds)
                                lift.previousInstance = previousLift
                                action()
                                
                                liftViewController = navigationController.topViewController as? LiftViewController
                            }
                            
                            it("presents the previous lift sheet") {
                                expect(liftViewController).toNot(beNil())
                            }
                            
                            describe("The presented lift sheet") {
                                it("displays the previous lift") {
                                    expect(liftViewController?.lift).to(beIdenticalTo(previousLift))
                                }
                                
                                it("is readonly") {
                                    expect(liftViewController?.isReadonly).to(beTrue())
                                }
                            }
                        }
                    }
                    
                    describe("Tapping the add lift button") {
                        beforeEach {
                            subject.addLiftButton?.tap()
                        }
                        
                        it("presents a modal allowing the user to enter set information") {
                            let modalSetEditForm = subject.presentedViewController as? SetEditModalViewController
                            
                            expect(modalSetEditForm).toNot(beNil())
                            expect(modalSetEditForm?.delegate as? LiftViewController).to(beIdenticalTo(subject))
                        }
                        
                        describe("Behavior as delegate of set edit form") {
                            describe("When queried for the lift data template") {
                                it("returns its lift's data template") {
                                    expect(subject.liftDataTemplate).to(equal(lift.dataTemplate))
                                }
                            }
                            
                            describe("When queried for the last set entered") {
                                var lastEnteredSet: LiftSet?
                                
                                context("When a previous set does not exist") {
                                    beforeEach {
                                        lastEnteredSet = subject.lastSetEntered
                                    }
                                    
                                    it("returns nil") {
                                        expect(lastEnteredSet).to(beNil())
                                    }
                                }
                                
                                context("When a previous set exists") {
                                    var firstSetAdded: LiftSet!
                                    var secondSetAdded: LiftSet!
                                    
                                    beforeEach {
                                        firstSetAdded = LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtles": 1])
                                        secondSetAdded = LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtles": 2])
                                        
                                        lift.addSet(firstSetAdded)
                                        lift.addSet(secondSetAdded)
                                        lastEnteredSet = subject.lastSetEntered
                                    }
                                    
                                    it("returns the last set entered") {
                                        expect(lastEnteredSet).to(beIdenticalTo(secondSetAdded))
                                    }
                                }
                            }
                            
                            describe("When the set edit form finishes") {
                                beforeEach {
                                    subject.setEnteredWithData(["turtles": 10000, "nonturtles": 1])
                                }
                                
                                it("adds a new set with the given data and the data template of the controller's lift") {
                                    expect(subject.lift.sets.count).to(equal(1))
                                    expect(subject.lift.sets[0].data["turtles"] as? Int).to(equal(10000))
                                    expect(subject.lift.sets[0].data["nonturtles"] as? Int).to(equal(1))
                                    expect(subject.lift.sets[0].dataTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                                }
                                
                                it("saves the workout with the new lift set on it") {
                                    let savedWorkout = mockWorkoutSaveAgent.savedWorkout
                                    expect(savedWorkout).toNot(beNil())
                                    let setWorkout = subject.lift.sets[0].lift?.workout
                                    expect(savedWorkout?.name).to(equal(setWorkout?.name))
                                }
                                
                                it("reloads the table view's data") {
                                    expect(subject.tableView?.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name, forIndexPath: NSIndexPath(forRow: 0, inSection: 0))).toNot(throwError())
                                }
                            }
                        }
                    }
                    
                    describe("Its data table") {
                        beforeEach {
                            subject.lift.addSet(LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtles": 100]))
                            subject.lift.addSet(LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtles": 200]))
                            subject.lift.addSet(LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtles": 300]))
                            subject.tableView?.reloadData()
                        }
                        
                        it("has one section") {
                            expect(subject.numberOfSectionsInTableView(subject.tableView!)).to(equal(1))
                        }
                        
                        it("has a header view") {
                            let headerView = subject.tableView(subject.tableView!,
                                                               viewForHeaderInSection: 0)
                            expect(headerView).to(beIdenticalTo(mockLiftTableHeaderViewProvider.providedView))
                            expect(subject.lift).to(beIdenticalTo(mockLiftTableHeaderViewProvider?.givenLift))
                        }
                        
                        it("has a number of rows equal to the number of sets in its lift model") {
                            expect(subject.tableView(subject.tableView!, numberOfRowsInSection: 0)).to(equal(3))
                        }
                        
                        describe("Its cells") {
                            let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                            let secondIndexPath = NSIndexPath(forRow: 1, inSection: 0)
                            let thirdIndexPath = NSIndexPath(forRow: 2, inSection: 0)
                            
                            var firstCell: LiftSetTableViewCell!
                            var secondCell: LiftSetTableViewCell!
                            var thirdCell: LiftSetTableViewCell!
                            
                            beforeEach {
                                firstCell = subject.tableView(subject.tableView!,
                                    cellForRowAtIndexPath: firstIndexPath) as! LiftSetTableViewCell
                                secondCell = subject.tableView(subject.tableView!,
                                    cellForRowAtIndexPath: secondIndexPath) as! LiftSetTableViewCell
                                thirdCell = subject.tableView(subject.tableView!,
                                    cellForRowAtIndexPath: thirdIndexPath) as! LiftSetTableViewCell
                            }
                            
                            it("uses the sets as models on the cells") {
                                expect(firstCell.set).to(beIdenticalTo(subject.lift.sets[0]))
                                expect(secondCell.set).to(beIdenticalTo(subject.lift.sets[1]))
                                expect(thirdCell.set).to(beIdenticalTo(subject.lift.sets[2]))
                            }
                            
                            describe("Selection") {
                                var setEditForm: SetEditModalViewController?
                                
                                beforeEach {
                                    subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                                    
                                    setEditForm = subject.presentedViewController as? SetEditModalViewController
                                }
                                
                                it("should present the set edit form for that set") {
                                    expect(setEditForm).toNot(beNil())
                                    expect(setEditForm?.delegate as? LiftViewController).to(beIdenticalTo(subject))
                                }
                                
                                it("sets the selected cell's set on the presented set edit modal") {
                                    expect(setEditForm?.set).to(beIdenticalTo(firstCell.set))
                                }
                                
                                describe("When the set entry form modal finishes") {
                                    beforeEach {
                                        subject.setEnteredWithData(["turtles": 20000, "nonturtles": 2])
                                    }
                                    
                                    it("will have the same number of sets as before the modal opened") {
                                        expect(subject.lift.sets.count).to(equal(3))
                                    }
                                    
                                    it("will have updated the selected cell's set with the values from the modal") {
                                        expect(subject.lift.sets[0].data["turtles"] as? Int).to(equal(20000))
                                        expect(subject.lift.sets[0].data["nonturtles"] as? Int).to(equal(2))
                                    }
                                    
                                    it("saves the workout with the updated set on it") {
                                        let savedWorkout = mockWorkoutSaveAgent.savedWorkout
                                        expect(savedWorkout).toNot(beNil())
                                        let setWorkout = subject.lift.sets[0].lift?.workout
                                        expect(savedWorkout?.name).to(equal(setWorkout?.name))
                                    }
                                    
                                    it("reloads the table view's data") {
                                        expect(subject.tableView?.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name, forIndexPath: NSIndexPath(forRow: 0, inSection: 0))).toNot(throwError())
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
