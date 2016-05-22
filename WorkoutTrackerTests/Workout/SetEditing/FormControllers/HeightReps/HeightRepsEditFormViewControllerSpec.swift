import Quick
import Nimble
import WorkoutTracker
import Swinject

class HeightRepsEditFormViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockSetEditFormDelegate: SetEditFormDelegate {
            var didFormChange: Bool = false
            var set: LiftSet? {
                get {
                    return LiftSet(withDataTemplate: .HeightReps, data: ["height": 12.0, "reps": 8])
                }
            }
            
            func onFormChanged() {
                didFormChange = true
            }
        }
        
        describe("HeightRepsEditFormViewController") {
            var subject: HeightRepsEditFormViewController!
            var container: Container!
            var mockSetEditFormDelegate: MockSetEditFormDelegate!
            
            beforeEach {
                container = Container()
                
                HeightRepsEditFormViewController.registerForInjection(container)
                
                subject = container.resolve(HeightRepsEditFormViewController.self)
                
                mockSetEditFormDelegate = MockSetEditFormDelegate()
                subject.delegate = mockSetEditFormDelegate
            }
            
            it("can be injected") {
                expect(subject).toNot(beNil())
            }
            
            // given "can be injected"
            describe("After the view has loaded") {
                beforeEach {
                    
                    TestAppDelegate.setAsRootViewController(subject)
                }
                
                it("fills out the height field with the data on the delegate's set") {
                    expect(subject.heightEntryInputField?.text).to(equal("12.0"))
                }
                
                it("fills out the reps field with the given data on the delegate's set") {
                    expect(subject.repsEntryInputField?.text).to(equal("8"))
                }
                
                describe("As a LiftSetEditFormController") {
                    describe("Its form") {
                        it("is the view controller's view") {
                            expect(subject.form).to(beIdenticalTo(subject.view))
                        }
                    }
                    
                    describe("Returning its form data") {
                        var formData: [String : AnyObject]?
                        
                        beforeEach {
                            subject.heightEntryInputField?.text = "155.5"
                            subject.repsEntryInputField?.text = "8"
                            formData = subject.enteredLiftData
                        }
                        
                        it("returns a dictionary containing the data from the height field") {
                            expect(formData?["height"] as? Double).to(equal(155.5))
                        }
                        
                        it("returns a dictionary containing the data from the reps field") {
                            expect(formData?["reps"] as? Int).to(equal(8))
                        }
                    }
                    
                    describe("The validity of the form") {
                        context("When all the form's fields are filled out") {
                            beforeEach {
                                subject.heightEntryInputField?.text = "123"
                                subject.repsEntryInputField?.text = "10"
                            }
                            
                            it("considers the form valid") {
                                expect(subject.isFormValid).to(beTrue())
                            }
                        }
                        
                        context("When not all of the form's fields are filled out") {
                            beforeEach {
                                subject.heightEntryInputField?.text = "123"
                                subject.repsEntryInputField?.text = ""
                            }
                            
                            it("does not consider the form valid") {
                                expect(subject.isFormValid).to(beFalse())
                            }
                        }
                    }
                    
                    describe("Clearing focus from fields") {
                        context("When height field is focused") {
                            beforeEach {
                                subject.heightEntryInputField?.becomeFirstResponder()
                                subject.removeCursorFromFields()
                            }
                            
                            it("unfocuses the height field") {
                                expect(subject.heightEntryInputField?.isFirstResponder()).to(beFalse())
                            }
                        }
                        
                        context("When reps field is focused") {
                            beforeEach {
                                subject.repsEntryInputField?.becomeFirstResponder()
                                subject.removeCursorFromFields()
                            }
                            
                            it("unfocuses the reps field") {
                                expect(subject.repsEntryInputField?.isFirstResponder()).to(beFalse())
                            }
                        }
                    }
                }
                
                describe("Editing the form") {
                    describe("When the height text field is edited") {
                        beforeEach {
                            subject.heightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("informs its delegate of the edit") {
                            expect(mockSetEditFormDelegate.didFormChange).to(beTrue())
                        }
                    }
                    
                    describe("When the reps text field is edited") {
                        beforeEach {
                            subject.repsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("informs its delegate of the edit") {
                            expect(mockSetEditFormDelegate.didFormChange).to(beTrue())
                        }
                    }
                }
            }
        }
    }
}
