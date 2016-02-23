import Quick
import Nimble
import Swinject
import WorkoutTracker

class WorkoutListViewControllerSpec: QuickSpec {
    override func spec() {
        describe("WorkoutListViewController") {
            var subject: WorkoutListViewController!
            var mockWorkoutListViewModel: MockWorkoutListViewModel!
            
            beforeEach {
                let container = Container()
                
                mockWorkoutListViewModel = MockWorkoutListViewModel()
                
                container.register(WorkoutListViewModel.self) { _ in mockWorkoutListViewModel }
                
                container.registerForStoryboard(WorkoutListViewController.self) { container, instance in
                    instance.viewModel = container.resolve(WorkoutListViewModel.self)
                }
                
                let storyboard = SwinjectStoryboard.create(name: "Workout", bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("WorkoutListViewController")
                            as! WorkoutListViewController
            }
            
            describe("Once the view has loaded") {
                beforeEach {
                    subject.view
                }
                
                it("should set the page's title") {
                    expect(subject.title).to(equal("Workouts"))
                }
                
                it("should set its view model as its table view's delegate") {
                    let delegate = subject.tableView?.delegate
                    expect(delegate === mockWorkoutListViewModel).to(beTrue())
                }
                
                it("should set its view model as its table view's data source") {
                    let dataSource = subject.tableView?.delegate
                    expect(dataSource === mockWorkoutListViewModel).to(beTrue())
                }
                
                it("should set up its table view with the view model") {
                    expect(mockWorkoutListViewModel.setUpTableView).to(beIdenticalTo(subject.tableView))
                }
                
                describe("Tapping the right nav bar item") {
                    beforeEach {
                        let navigationItem = subject.navigationItem
                        let rightNavigationBarButtonItem = navigationItem.rightBarButtonItem!
                        UIApplication.sharedApplication().sendAction(rightNavigationBarButtonItem.action, to: rightNavigationBarButtonItem.target, from: nil, forEvent: nil)
                    }
                    
                    it("adds a new item") {
                        expect(mockWorkoutListViewModel.workouts.count).to(equal(1))
                    }
                }
            }
        }
    }
}

class MockWorkoutListViewModel: WorkoutListViewModel {
    init() { super.init(withTimestamper: Timestamper()) }
    var setUpTableView: UITableView?
    
    override func setUpTableView(tableView: UITableView) {
        setUpTableView = tableView
    }
}
