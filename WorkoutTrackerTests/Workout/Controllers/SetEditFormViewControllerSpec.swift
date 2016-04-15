import Quick
import Nimble
import Fleet
import Swinject
import WorkoutTracker

class SetEditFormViewControllerSpec: QuickSpec {
    override func spec() {
        class MockSetEditFormDelegate: SetEditFormDelegate {
            var enteredWeight: Double?
            var enteredReps: Int?
            var internalLastSetEntered: LiftSet?
            var canceled: Bool = false
            
            var lastSetEntered: LiftSet? {
                get {
                    return internalLastSetEntered
                }
                set {
                    internalLastSetEntered = newValue
                }
            }
            
            func setEnteredWithWeight(weight: Double, reps: Int) {
                enteredWeight = weight
                enteredReps = reps
            }
            
            func editCanceled() {
                canceled = true
            }
        }
        
        describe("SetEditFormViewController") {
            var subject: SetEditFormViewController!
            var mockSetEditFormDelegate: MockSetEditFormDelegate!
            
            beforeEach {
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil,
                    container: storyboardMetadata.container)
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
                    
                    it("attaches a tap gesture recognizer to the background view") {
                        expect(subject.tapGestureRecognizer?.view).to(beIdenticalTo(subject.backgroundView))
                    }
                    
                    describe("Entering form data and submitting") {
                        beforeEach {
                            subject.weightEntryInputField?.text = "235"
                            subject.repsEntryInputField?.text = "3"
                            subject.formSubmitButton?.tap()
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
                        set = LiftSet(withTargetWeight: nil, performedWeight: 100,
                            targetReps: nil, performedReps: 10)
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
                    
                    it("hides the 'Add Previous' button") {
                        expect(subject.addPreviousButton?.hidden).to(beTrue())
                    }
                    
                    itBehavesLike("Editing and committing changes to the set")
                }
                
                context("A set has not been set on the controller") {
                    beforeEach {
                        subject.set = nil
                    }
                    
                    sharedExamples("A set is not yet on the controller") {
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
                    
                    context("The delegate has a previous set") {
                        beforeEach {
                            let previousSet = LiftSet(withTargetWeight: nil, performedWeight: 100,
                                targetReps: nil, performedReps: 10)
                            mockSetEditFormDelegate.internalLastSetEntered = previousSet
                            TestAppDelegate.setAsRootViewController(subject)
                        }
                        
                        it("shows the 'Add Previous' button") {
                            expect(subject.addPreviousButton?.hidden).to(beFalse())
                        }
                        
                        describe("Tapping the 'Add Previous' button") {
                            beforeEach {
                                subject.addPreviousButton?.tap()
                            }
                            
                            it("populates the weight form field with the last set's weight") {
                                expect(subject.weightEntryInputField?.text).to(equal("100.0"))
                            }
                            
                            it("populates the reps form field with the last set's reps") {
                                expect(subject.repsEntryInputField?.text).to(equal("10"))
                            }
                            
                            it("passes the form data along to its delegate") {
                                expect(mockSetEditFormDelegate.enteredWeight).to(equal(100))
                                expect(mockSetEditFormDelegate.enteredReps).to(equal(10))
                            }
                        }
                        
                        itBehavesLike("A set is not yet on the controller")
                    }
                    
                    context("The delegate does not have a previous set") {
                        beforeEach {
                            mockSetEditFormDelegate.internalLastSetEntered = nil
                            TestAppDelegate.setAsRootViewController(subject)
                        }
                        
                        it("hides the 'Add Previous' button") {
                            expect(subject.addPreviousButton?.hidden).to(beTrue())
                        }
                        
                        itBehavesLike("A set is not yet on the controller")
                    }
                }
                
                describe("Tapping outside the modal") {
                    beforeEach {
                        TestAppDelegate.setAsRootViewController(subject)
                        
                        subject.handleTapOutsideModal()
                    }
                    
                    it("cancels the modal") {
                        expect(mockSetEditFormDelegate.canceled).to(beTrue())
                    }
                }
            }
        }
    }
}
