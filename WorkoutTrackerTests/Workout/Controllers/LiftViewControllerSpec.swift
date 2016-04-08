import Quick
import Nimble
import Swinject
import WorkoutTracker

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
        
        describe("LiftViewController") {
            var subject: LiftViewController!
            var mockWorkoutSaveAgent: MockWorkoutSaveAgent!
            var navigationController: TestNavigationController!
            var lift: Lift!
            
            beforeEach {
                mockWorkoutSaveAgent = MockWorkoutSaveAgent()
                
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let container = storyboardMetadata.container
                container.register(WorkoutSaveAgent.self) { resolver in
                    return mockWorkoutSaveAgent
                }
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("LiftViewController")
                    as! LiftViewController
                
                lift = Lift(withName: "turtle deadlift")
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
                        var setEditForm: SetEditFormViewController?
                        
                        beforeEach {
                            let set = LiftSet(withTargetWeight: nil, performedWeight: 100,
                                targetReps: nil, performedReps: 1)
                            subject.lift.addSet(set)
                            subject.tableView?.reloadData()
                            
                            let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                            subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                            setEditForm = subject.presentedViewController as? SetEditFormViewController
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
                                previousLift = Lift(withName: lift.name)
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
                            subject.addLiftButton?.sendActionsForControlEvents(.TouchUpInside)
                        }
                        
                        it("presents a modal allowing the user to enter set information") {
                            let modalSetEditForm = subject.presentedViewController as? SetEditFormViewController
                            
                            expect(modalSetEditForm).toNot(beNil())
                            expect(modalSetEditForm?.delegate as? LiftViewController).to(beIdenticalTo(subject))
                        }
                        
                        describe("Behavior as delegate of set entry form modal") {
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
                                        firstSetAdded = LiftSet(withTargetWeight: nil, performedWeight: 100,
                                            targetReps: nil, performedReps: 10)
                                        secondSetAdded = LiftSet(withTargetWeight: nil, performedWeight: 200,
                                            targetReps: nil, performedReps: 5)
                                        
                                        lift.addSet(firstSetAdded)
                                        lift.addSet(secondSetAdded)
                                        lastEnteredSet = subject.lastSetEntered
                                    }
                                    
                                    it("returns the last set entered") {
                                        expect(lastEnteredSet).to(beIdenticalTo(secondSetAdded))
                                    }
                                }
                            }
                            
                            describe("When the set entry form modal finishes") {
                                beforeEach {
                                    subject.setEnteredWithWeight(135, reps: 10)
                                }
                                
                                it("adds a new set with the given weight and reps") {
                                    expect(subject.lift.sets.count).to(equal(1))
                                    expect(subject.lift.sets[0].performedWeight).to(equal(135))
                                    expect(subject.lift.sets[0].performedReps).to(equal(10))
                                }
                                
                                it("saves the workout with the new lift set on it") {
                                    let savedWorkout = mockWorkoutSaveAgent.savedWorkout
                                    expect(savedWorkout).toNot(beNil())
                                    let setWorkout = subject.lift.sets[0].lift?.workout
                                    expect(savedWorkout?.name).to(equal(setWorkout?.name))
                                }
                                
                                it("dismisses the set entry form modal") {
                                    expect(subject.presentedViewController).toEventually(beNil(), timeout:2.0)
                                }
                                
                                it("reloads the table view's data") {
                                    expect(subject.tableView?.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name, forIndexPath: NSIndexPath(forRow: 0, inSection: 0))).toNot(throwError())
                                }
                            }
                            
                            describe("When the set entry form modal is canceled") {
                                beforeEach {
                                    subject.editCanceled()
                                }
                                
                                it("dismisses the set entry form modal") {
                                    expect(subject.presentedViewController).toEventually(beNil(), timeout:2.0)
                                }
                            }
                        }
                    }
                    
                    describe("Its data table") {
                        beforeEach {
                            subject.lift.addSet(LiftSet(withTargetWeight: nil, performedWeight: 100,
                                targetReps: nil, performedReps: 1))
                            subject.lift.addSet(LiftSet(withTargetWeight: nil, performedWeight: 200,
                                targetReps: nil, performedReps: 2))
                            subject.lift.addSet(LiftSet(withTargetWeight: nil, performedWeight: 300,
                                targetReps: nil, performedReps: 3))
                            subject.tableView?.reloadData()
                        }
                        
                        it("has one section") {
                            expect(subject.numberOfSectionsInTableView(subject.tableView!)).to(equal(1))
                        }
                        
                        it("has a header view") {
                            let headerView = subject.tableView(subject.tableView!,
                                viewForHeaderInSection: 0) as? LiftTableViewHeaderView
                            expect(headerView).toNot(beNil())
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
                            
                            it("numbers the sets correctly in the cell list") {
                                expect(firstCell.setNumberLabel?.text).to(equal("1"))
                                expect(secondCell.setNumberLabel?.text).to(equal("2"))
                                expect(thirdCell.setNumberLabel?.text).to(equal("3"))
                            }
                            
                            describe("Selection") {
                                var setEditForm: SetEditFormViewController?
                                
                                beforeEach {
                                    subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                                    
                                    setEditForm = subject.presentedViewController as? SetEditFormViewController
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
                                        subject.setEnteredWithWeight(235, reps: 8)
                                    }
                                    
                                    it("will have the same number of sets as before the modal opened") {
                                        expect(subject.lift.sets.count).to(equal(3))
                                    }
                                    
                                    it("will have updated the selected cell's set with the values from the modal") {
                                        expect(subject.lift.sets[0].performedWeight).to(equal(235))
                                        expect(subject.lift.sets[0].performedReps).to(equal(8))
                                    }
                                    
                                    it("saves the workout with the updated set on it") {
                                        let savedWorkout = mockWorkoutSaveAgent.savedWorkout
                                        expect(savedWorkout).toNot(beNil())
                                        let setWorkout = subject.lift.sets[0].lift?.workout
                                        expect(savedWorkout?.name).to(equal(setWorkout?.name))
                                    }
                                    
                                    it("dismisses the set entry form modal") {
                                        expect(subject.presentedViewController).toEventually(beNil(), timeout:2.0)
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
