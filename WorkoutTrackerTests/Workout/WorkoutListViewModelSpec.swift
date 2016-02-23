import Quick
import Nimble
import WorkoutTracker

class WorkoutListViewModelSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListViewModel") {
            var subject: WorkoutListViewModel!
            var mockTimestamper: MockTimestamper!
            
            beforeEach {
                mockTimestamper = MockTimestamper()
                subject = WorkoutListViewModel(withTimestamper: mockTimestamper)
            }
            
            describe("Its intializer") {
                it("sets its timestamper") {
                    expect(subject.timestamper).to(beIdenticalTo(mockTimestamper))
                }
            }
            
            describe("Adding a workout to the list") {
                beforeEach {
                    mockTimestamper.timestamp = 123456789
                    subject.createNewWorkout()
                }
                
                it("adds a workout to the view model's list") {
                    expect(subject.workouts.count).to(equal(1))
                }
                
                describe("The created workout") {
                    var addedWorkout: WorkoutIdentifier!
                    
                    beforeEach {
                        addedWorkout = subject.workouts.first
                    }
                    
                    it("is created with the current time as its timestamp") {
                        expect(addedWorkout.timestamp).to(equal(123456789))
                    }
                }
            }

            describe("Setting up a table view") {
                var realTableView: UITableView!
                
                beforeEach {
                    realTableView = UITableView()
                    subject.setUpTableView(realTableView)
                }
                
                it("registers the WorkoutListTableViewCell") {
                    let realCell = realTableView.dequeueReusableCellWithIdentifier(WorkoutListTableViewCell.reuseIdentifier)
                    expect(realCell).toNot(beNil())
                }
            }
            
            describe("As a table view data source") {
                var mockTableView: MockUITableView!
                
                beforeEach {
                    mockTimestamper.timestamp = 644569200 // June 05, 1990 12:00AM
                    subject.createNewWorkout()
                    
                    mockTimestamper.timestamp = 1149490800 // June 05, 2006 12:00AM
                    subject.createNewWorkout()
                    
                    mockTimestamper.timestamp = 1307257200 // June 05, 2011 12:00AM
                    subject.createNewWorkout()
                    
                    mockTableView = MockUITableView()
                }
                
                it("has a row for each workout") {
                    expect(subject.tableView(mockTableView, numberOfRowsInSection: 0)).to(equal(3))
                }
                
                describe("Its cells") {
                    var firstCell: WorkoutListTableViewCell!
                    var secondCell: WorkoutListTableViewCell!
                    var thirdCell: WorkoutListTableViewCell!
                    
                    beforeEach {
                        firstCell = subject.tableView(mockTableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! WorkoutListTableViewCell
                        secondCell = subject.tableView(mockTableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! WorkoutListTableViewCell
                        thirdCell = subject.tableView(mockTableView, cellForRowAtIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! WorkoutListTableViewCell
                    }
                    
                    it("sets the date and time as its cells' label content") {
                        expect(firstCell.contentLabel).toNot(beNil())
                        expect(secondCell.contentLabel).toNot(beNil())
                        expect(thirdCell.contentLabel).toNot(beNil())
                        
                        expect(firstCell.contentLabel?.text).to(equal("06/05/1990, 12:00AM"))
                        expect(secondCell.contentLabel?.text).to(equal("06/05/2006, 12:00AM"))
                        expect(thirdCell.contentLabel?.text).to(equal("06/05/2011, 12:00AM"))
                    }
                }
            }
        }
    }
}

class MockTimestamper: Timestamper {
    var timestamp: Int!
    
    override func getTimestamp() -> Int {
        return timestamp
    }
}

class MockUITableView: UITableView {
    override func dequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell? {
        let cell = MockWorkoutListTableViewCell()
        cell.createLabel()
        return cell
    }
}

class MockWorkoutListTableViewCell: WorkoutListTableViewCell {
    var strongLabel: UILabel!
    func createLabel() {
        strongLabel = UILabel()
        contentLabel = strongLabel
    }
}
