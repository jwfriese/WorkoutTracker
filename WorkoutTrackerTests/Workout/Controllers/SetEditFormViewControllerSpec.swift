import Quick
import Nimble
import Swinject
import WorkoutTracker

class SetEditFormViewControllerSpec: QuickSpec {
    override func spec() {
        describe("SetEditFormViewController") {
            var subject: SetEditFormViewController!
            var mockSetEditFormDelegate: MockSetEditFormDelegate!
            
            beforeEach {
                let storyboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name, bundle: nil, container: WorkoutStoryboardMetadata.container)
                subject = storyboard.instantiateViewControllerWithIdentifier("SetEditFormViewController")
                    as! SetEditFormViewController
                mockSetEditFormDelegate = MockSetEditFormDelegate()
                subject.delegate = mockSetEditFormDelegate
            }
            
            describe("After the view has loaded") {
                sharedExamples("Editing and committing changes to the set") {
                    it("adjusts the width and color of its border") {
                        expect(subject.formContentView?.layer.borderWidth).to(equal(2.0))
                        
                        let colorsEqual = CGColorEqualToColor(subject.formContentView?.layer.borderColor,
                            UIColor.grayColor().CGColor)
                        expect(colorsEqual).to(beTruthy())
                    }
                    
                    describe("Availability of the form submit button") {
                        context("When weight text field is empty") {
                            beforeEach {
                                subject.weightEntryInputField?.text = ""
                                subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            }
                            
                            it("disables the form submit button") {
                                expect(subject.formSubmitButton?.enabled).to(beFalse())
                            }
                        }
                        
                        context("When reps text field is empty") {
                            beforeEach {
                                subject.repsEntryInputField?.text = ""
                                subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            }
                            
                            it("disables the form submit button") {
                                expect(subject.formSubmitButton?.enabled).to(beFalse())
                            }
                        }
                        
                        context("When both text fields have any nonwhitespace text in it") {
                            beforeEach {
                                subject.weightEntryInputField?.text = "∑"
                                subject.repsEntryInputField?.text = "∑"
                                subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                                subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            }
                            
                            it("enables the submit button") {
                                expect(subject.formSubmitButton?.enabled).to(beTrue())
                            }
                            
                            context("When the text fields' content is deleted") {
                                beforeEach {
                                    subject.weightEntryInputField?.text = ""
                                    subject.repsEntryInputField?.text = ""
                                    subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                                    subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                                }
                                
                                it("disables the form submit button") {
                                    expect(subject.formSubmitButton?.enabled).to(beFalse())
                                }
                            }
                        }
                    }
                    
                    describe("Entering form data and submitting") {
                        beforeEach {
                            subject.weightEntryInputField?.text = "235"
                            subject.repsEntryInputField?.text = "3"
                            subject.formSubmitButton?.sendActionsForControlEvents(.TouchUpInside)
                        }
                        
                        it("passes the form data along to its delegate") {
                            expect(mockSetEditFormDelegate.enteredWeight).to(equal(235))
                            expect(mockSetEditFormDelegate.enteredReps).to(equal(3))
                        }
                    }
                }
                
                context("A set is already set on the controller") {
                    var set: LiftSet!
                    
                    beforeEach {
                        set = LiftSet(withWeight: 100, reps: 10)
                        subject.set = set
                        TestAppDelegate.setAsRootViewController(subject)
                    }
                    
                    it("sets the form submit button's text to 'Save'") {
                        expect(subject.formSubmitButton?.titleLabel?.text).to(equal("Save"))
                    }
                    
                    it("populates the weight text field with the set's weight") {
                        expect(subject.weightEntryInputField?.text).to(equal("100.0"))
                    }
                    
                    it("populates the reps text field with the set's rep count") {
                        expect(subject.repsEntryInputField?.text).to(equal("10"))
                    }
                    
                    it("does not focus the cursor in either text field") {
                        expect(subject.weightEntryInputField?.isFirstResponder()).to(beFalse())
                        expect(subject.repsEntryInputField?.isFirstResponder()).to(beFalse())
                    }
                    
                    it("does not disable the form submit button") {
                        expect(subject.formSubmitButton?.enabled).to(beTrue())
                    }
                    
                    itBehavesLike("Editing and committing changes to the set")
                }
                
                context("A set has not been set on the controller") {
                    beforeEach {
                        subject.set = nil
                        TestAppDelegate.setAsRootViewController(subject)
                    }
                    
                    it("sets the form submit button's text to 'Add'") {
                        expect(subject.formSubmitButton?.titleLabel?.text).to(equal("Add"))
                    }
                    
                    it("focuses the cursor in the weight entry input field") {
                        expect(subject.weightEntryInputField?.isFirstResponder()).to(beTrue())
                    }
                    
                    it("creates an empty set for the controller") {
                        expect(subject.set).toNot(beNil())
                    }
                    
                    it("disables the form submit button") {
                        expect(subject.formSubmitButton?.enabled).to(beFalse())
                    }
                    
                    itBehavesLike("Editing and committing changes to the set")
                }
            }
        }
    }
}

class MockSetEditFormDelegate: SetEditFormDelegate {
    var enteredWeight: Double?
    var enteredReps: Int?
    
    func setEnteredWithWeight(weight: Double, reps: Int) {
        enteredWeight = weight
        enteredReps = reps
    }
}
