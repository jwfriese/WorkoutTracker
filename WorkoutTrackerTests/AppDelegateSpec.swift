import Quick
import Nimble
import WorkoutTracker

class AppDelegateSpec: QuickSpec {
    override func spec() {
        var subject: AppDelegate!
        
        beforeEach {
            subject = AppDelegate()
        }
        
        describe("Startup") {
            beforeEach {
                subject.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
            }
            
            it("should set up a root view controller that is a UINavigationController") {
                expect(subject.window).toNot(beNil())
                expect(subject.window?.rootViewController).to(beAnInstanceOf(UINavigationController.self))
            }
            
            describe("Initial navigation controller content") {
                var navigationController: UINavigationController!
                var topViewController: UIViewController!
                
                beforeEach {
                    navigationController = subject.window?.rootViewController as? UINavigationController
                    topViewController = navigationController.topViewController
                }
                
                it("should set the top view controller of the navigation controller to be a WorkoutListViewController") {
                    expect(topViewController).to(beAnInstanceOf(WorkoutListViewController.self))
                }
            }
            
            it("should make its window visible and the key window") {
                expect(subject.window?.keyWindow).to(beTrue())
            }
        }
    }
}
