import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutViewControllerSpec: QuickSpec {
    override func spec() {
        describe("WorkoutViewController") {
            var subject: WorkoutViewController!
            var navigationController: TestNavigationController!
            
            beforeEach {
                let storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: WorkoutStoryboardMetadata.container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController")
                    as! WorkoutViewController
                
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
                
                it("should have created a model object for itself") {
                    expect(subject.workout).toNot(beNil())
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
                        }
                        
                        it("adds a new lift with the given name") {
                            expect(subject.workout.lifts.count).to(equal(1))
                            expect(subject.workout.lifts.first?.name).to(equal("turtle lift"))
                        }
                        
                        it("dismisses the lift entry form modal") {
                            expect(subject.presentedViewController).toEventually(beNil(), timeout:2.0)
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
                    }
                }
            }
        }
    }
}
