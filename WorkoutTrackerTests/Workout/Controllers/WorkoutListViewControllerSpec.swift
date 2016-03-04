import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutListViewControllerSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListViewController") {
            var subject: WorkoutListViewController!
            var mockTimestamper: MockTimestamper!
            
            var navigationController: TestNavigationController!
            
            beforeEach {
                let container = Container()
                
                mockTimestamper = MockTimestamper()
                
                container.register(Timestamper.self) { _ in mockTimestamper }
                
                container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
                    instance.timestamper = resolver.resolve(Timestamper.self)
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
                
                describe("Tapping the right nav bar item") {
                    beforeEach {
                        let navigationItem = subject.navigationItem
                        let rightNavigationBarButtonItem = navigationItem.rightBarButtonItem!
                        UIApplication.sharedApplication().sendAction(rightNavigationBarButtonItem.action, to: rightNavigationBarButtonItem.target, from: nil, forEvent: nil)
                    }
                    
                    it("adds a new item") {
                        expect(subject.workouts.count).to(equal(1))
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
                        expect(subject.tableView(subject.tableView!, numberOfRowsInSection: 0)).to(equal(3))
                    }
                    
                    describe("Its cells") {
                        let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                        let secondIndexPath = NSIndexPath(forRow: 1, inSection: 0)
                        let thirdIndexPath = NSIndexPath(forRow: 2, inSection: 0)
                        
                        var firstCell: WorkoutListTableViewCell!
                        var secondCell: WorkoutListTableViewCell!
                        var thirdCell: WorkoutListTableViewCell!
                        
                        beforeEach {
                            firstCell = subject.tableView(subject.tableView!, cellForRowAtIndexPath: firstIndexPath) as! WorkoutListTableViewCell
                            secondCell = subject.tableView(subject.tableView!, cellForRowAtIndexPath: secondIndexPath) as! WorkoutListTableViewCell
                            thirdCell = subject.tableView(subject.tableView!, cellForRowAtIndexPath: thirdIndexPath) as! WorkoutListTableViewCell
                        }
                        
                        it("sets each cell with the correct workout") {
                            expect(firstCell.workout).to(beIdenticalTo(subject.workouts[0]))
                            expect(secondCell.workout).to(beIdenticalTo(subject.workouts[1]))
                            expect(thirdCell.workout).to(beIdenticalTo(subject.workouts[2]))
                        }
                        
                        describe("Selecting a cell") {
                            beforeEach {
                                subject.tableView(subject.tableView!, didSelectRowAtIndexPath: firstIndexPath)
                            }
                            
                            it("should present the page for that workout") {
                                expect(navigationController.topViewController).to(beAnInstanceOf(WorkoutViewController.self))
                            }
                            
                            it("sets the selected cell's lift on the presented lift page") {
                                let workoutViewController = navigationController.topViewController as? WorkoutViewController
                                expect(workoutViewController?.workout).to(beIdenticalTo(firstCell.workout))
                            }
                        }
                    }
                }
            }
        }
    }
}

class MockTimestamper: Timestamper {
    var timestamp: UInt!
    
    override func getTimestamp() -> UInt {
        if let timestamp = timestamp {
            return timestamp
        }
        
        return 0
    }
}
