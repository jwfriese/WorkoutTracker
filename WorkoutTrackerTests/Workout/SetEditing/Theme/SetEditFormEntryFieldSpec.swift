import Quick
import Nimble
@testable import WorkoutTracker

class SetEditFormEntryFieldSpec: QuickSpec {
    override func spec() {
        describe("SetEditFormEntryField") {
            var subject: SetEditFormEntryField!
            
            beforeEach {
                let testBundle = NSBundle.currentTestBundle
                let customViewElements = testBundle!.loadNibNamed("CustomViewElements", owner: nil, options: nil)[0] as? CustomViewElements
                subject = customViewElements!.setEditFormEntryField!
            }
            
            it("disables paste") {
                expect(subject.canPerformAction(#selector(NSObject.paste(_:)), withSender: nil)).to(beFalse())
            }
        }
    }
}
