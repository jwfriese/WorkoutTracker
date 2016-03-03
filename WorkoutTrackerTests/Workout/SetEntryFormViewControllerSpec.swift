import Quick
import Nimble
import Swinject
import WorkoutTracker

class SetEntryFormViewControllerSpec: QuickSpec {
    override func spec() {
        describe("SetEntryFormViewController") {
            var subject: SetEntryFormViewController!
            var mockSetEntryFormDelegate: MockSetEntryFormDelegate!
            
            beforeEach {
                let storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: WorkoutStoryboardMetadata.container)
                subject = storyboard.instantiateViewControllerWithIdentifier("SetEntryFormViewController")
                    as! SetEntryFormViewController
                mockSetEntryFormDelegate = MockSetEntryFormDelegate()
                subject.delegate = mockSetEntryFormDelegate
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
                
                it("focuses the cursor in the weight entry input field") {
                    expect(subject.weightEntryInputField?.isFirstResponder()).to(beTrue())
                }
                
                it("disables the 'Add' button") {
                    expect(subject.addButton?.enabled).to(beFalse())
                }
                
                describe("Availability of the 'Add' button") {
                    context("When weight text field is empty") {
                        beforeEach {
                            subject.weightEntryInputField?.text = ""
                            subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("disables the 'Add' button") {
                            expect(subject.addButton?.enabled).to(beFalse())
                        }
                    }
                    
                    context("When reps text field is empty") {
                        beforeEach {
                            subject.repsEntryInputField?.text = ""
                            subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("disables the 'Add' button") {
                            expect(subject.addButton?.enabled).to(beFalse())
                        }
                    }
                    
                    context("When both text fields have any nonwhitespace text in it") {
                        beforeEach {
                            subject.weightEntryInputField?.text = "∑"
                            subject.repsEntryInputField?.text = "∑"
                            subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("enables the 'Add' button") {
                            expect(subject.addButton?.enabled).to(beTrue())
                        }
                        
                        context("When the text fields' content is deleted") {
                            beforeEach {
                                subject.weightEntryInputField?.text = ""
                                subject.repsEntryInputField?.text = ""
                                subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                                subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            }
                            
                            it("disables the 'Add' button") {
                                expect(subject.addButton?.enabled).to(beFalse())
                            }
                        }
                    }
                }
                
                describe("Entering form data and submitting") {
                    beforeEach {
                        subject.weightEntryInputField?.text = "235"
                        subject.repsEntryInputField?.text = "3"
                        subject.addButton?.sendActionsForControlEvents(.TouchUpInside)
                    }
                    
                    it("passes the form data along to its delegate") {
                        expect(mockSetEntryFormDelegate.enteredWeight).to(equal(235))
                        expect(mockSetEntryFormDelegate.enteredReps).to(equal(3))
                    }
                }
            }
        }
    }
}

class MockSetEntryFormDelegate: SetEntryFormDelegate {
    var enteredWeight: Double?
    var enteredReps: Int?
    
    func setEnteredWithWeight(weight: Double, reps: Int) {
        enteredWeight = weight
        enteredReps = reps
    }
}
