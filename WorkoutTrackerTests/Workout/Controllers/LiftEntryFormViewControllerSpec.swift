import Quick
import Nimble
import Swinject
import WorkoutTracker

class LiftEntryFormViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftEntryFormDelegate: LiftEntryFormDelegate {
            var enteredName: String?
            
            func liftEnteredWithName(name: String) {
                enteredName = name
            }
        }
        
        describe("LiftEntryFormViewController") {
            var subject: LiftEntryFormViewController!
            var mockLiftEntryFormDelegate: MockLiftEntryFormDelegate!
            
            beforeEach {
                let storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: WorkoutStoryboardMetadata.container)
                subject = storyboard.instantiateViewControllerWithIdentifier("LiftEntryFormViewController")
                    as! LiftEntryFormViewController
                mockLiftEntryFormDelegate = MockLiftEntryFormDelegate()
                subject.delegate = mockLiftEntryFormDelegate
                TestAppDelegate.setAsRootViewController(subject)
            }
            
            describe("After the view has loaded") {
                beforeEach {
                    subject.view
                }
                
                it("adjusts the width and color of its border") {
                    expect(subject.formContentView?.layer.borderWidth).to(equal(2.0))
                    
                    let colorsEqual = CGColorEqualToColor(subject.formContentView?.layer.borderColor,
                        UIColor.grayColor().CGColor)
                    expect(colorsEqual).to(beTruthy())
                }
                
                it("focuses the cursor in the name entry input field") {
                    expect(subject.nameEntryInputField?.isFirstResponder()).to(beTrue())
                }
                
                it("disables the 'Create' button") {
                    expect(subject.createButton?.enabled).to(beFalse())
                }
                
                describe("Availability of the 'Create' button") {
                    context("When text field is empty") {
                        beforeEach {
                            subject.nameEntryInputField?.text = ""
                            subject.nameEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("disables the 'Create' button") {
                            expect(subject.createButton?.enabled).to(beFalse())
                        }
                    }
                    
                    context("When text field has any nonwhitespace text in it") {
                        beforeEach {
                            subject.nameEntryInputField?.text = "∑"
                            subject.nameEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("enables the 'Create' button") {
                            expect(subject.createButton?.enabled).to(beTrue())
                        }
                        
                        context("When the text field's content is deleted") {
                            beforeEach {
                                subject.nameEntryInputField?.text = ""
                                subject.nameEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            }
                            
                            it("disables the 'Create' button") {
                                expect(subject.createButton?.enabled).to(beFalse())
                            }
                        }
                    }
                }
                
                describe("Entering form data and submitting") {
                    beforeEach {
                        subject.nameEntryInputField?.text = "turtle grace"
                        subject.createButton?.sendActionsForControlEvents(.TouchUpInside)
                    }
                    
                    it("passes the form data along to its delegate") {
                        expect(mockLiftEntryFormDelegate.enteredName).to(equal("turtle grace"))
                    }
                }
            }
        }
    }
}
