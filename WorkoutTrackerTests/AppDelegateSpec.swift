import Quick
import Nimble
@testable import WorkoutTracker

class AppDelegateSpec: QuickSpec {
    override func spec() {
        var subject: AppDelegate!
        
        beforeEach {
            subject = AppDelegate()
        }
        
        describe("Startup behavior") {
            beforeEach {
                subject.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
            }
            
            it("should set up a root view controller that is a UINavigationController") {
                expect(subject.window).toNot(beNil())
                expect(subject.window?.rootViewController).to(beAnInstanceOf(UINavigationController.self))
            }
            
            describe("Initial navigation controller content") {
                var navigationController: UINavigationController!
                var startupViewController: StartupViewController?
                
                beforeEach {
                    navigationController = subject.window?.rootViewController as? UINavigationController
                    startupViewController = navigationController.topViewController as? StartupViewController
                }
                
                it("should set the top view controller of the navigation controller to be a StartupViewController") {
                    expect(startupViewController).toNot(beNil())
                }
                
                describe("The instantiated StartupViewController") {
                    it("has an instance of a MigrationAgent") {
                        expect(startupViewController?.migrationAgent).toNot(beNil())
                    }
                }
            }
            
            it("should make its window visible and the key window") {
                expect(subject.window?.keyWindow).to(beTrue())
            }
        }
    }
}
