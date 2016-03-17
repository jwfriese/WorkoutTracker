import Quick
import Nimble
import Swinject
import WorkoutTracker

class LiftViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockWorkoutSaveAgent: WorkoutSaveAgent {
            var savedWorkout: Workout?
            
            init() {
                super.init(withWorkoutSerializer: nil, localStorageWorker: nil)
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
                
                let container = WorkoutStoryboardMetadata.container
                container.register(WorkoutSaveAgent.self) { resolver in
                    return mockWorkoutSaveAgent
                }
                
                let storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("LiftViewController")
                    as! LiftViewController
                
                lift = Lift(withName: "turtle deadlift")
                lift.workout = Workout(withName: "turtle workout", timestamp: 1000)
                subject.lift = lift
                
                navigationController = TestNavigationController()
                navigationController.pushViewController(subject, animated: false)
                
                TestAppDelegate.setAsRootViewController(navigationController)
            }
            
            describe("After the view has loaded") {
                beforeEach {
                    subject.view
                }
                
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
                
                describe("Tapping the right nav bar item") {
                    beforeEach {
                        let navigationItem = subject.navigationItem
                        let rightNavigationBarButtonItem = navigationItem.rightBarButtonItem!
                        UIApplication.sharedApplication().sendAction(rightNavigationBarButtonItem.action, to: rightNavigationBarButtonItem.target, from: nil, forEvent: nil)
                    }
                    
                    it("presents a modal allowing the user to enter set information") {
                        let modalSetEditForm = subject.presentedViewController as? SetEditFormViewController
                        
                        expect(modalSetEditForm).toNot(beNil())
                        expect(modalSetEditForm?.delegate as? LiftViewController).to(beIdenticalTo(subject))
                    }
                    
                    describe("When the set entry form modal finishes") {
                        beforeEach {
                            subject.setEnteredWithWeight(135, reps: 10)
                        }
                        
                        it("adds a new set with the given weight and reps") {
                            expect(subject.lift.sets.count).to(equal(1))
                            expect(subject.lift.sets[0].weight).to(equal(135))
                            expect(subject.lift.sets[0].reps).to(equal(10))
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
                                    firstSetAdded = LiftSet(withWeight: 100, reps: 10)
                                    secondSetAdded = LiftSet(withWeight: 200, reps: 5)
                                    
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
                                expect(subject.lift.sets[0].weight).to(equal(135))
                                expect(subject.lift.sets[0].reps).to(equal(10))
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
                    }
                }
                
                describe("Its data table") {
                    beforeEach {
                        subject.lift.addSet(LiftSet(withWeight: 100, reps: 1))
                        subject.lift.addSet(LiftSet(withWeight: 200, reps: 2))
                        subject.lift.addSet(LiftSet(withWeight: 300, reps: 3))
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
                                    expect(subject.lift.sets[0].weight).to(equal(235))
                                    expect(subject.lift.sets[0].reps).to(equal(8))
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
