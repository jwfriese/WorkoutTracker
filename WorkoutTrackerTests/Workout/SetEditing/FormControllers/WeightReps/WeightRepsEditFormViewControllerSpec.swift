import Quick
import Nimble
import WorkoutTracker
import Swinject

class WeightRepsEditFormViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockSetEditFormDelegate: SetEditFormDelegate {
            var didFormChange: Bool = false
            var set: LiftSet? {
                get {
                    return LiftSet(withDataTemplate: .WeightReps, data: ["weight": 88.5, "reps": 7])
                }
            }
            
            func onFormChanged() {
                didFormChange = true
            }
        }
        
        describe("WeightRepsEditFormViewController") {
            var subject: WeightRepsEditFormViewController!
            var container: Container!
            var mockSetEditFormDelegate: MockSetEditFormDelegate!
            
            beforeEach {
                container = Container()
                
                WeightRepsEditFormViewController.registerForInjection(container)
                
                subject = container.resolve(WeightRepsEditFormViewController.self)
                
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
                
                it("fills out the weight field with the data on the delegate's set") {
                    expect(subject.weightEntryInputField?.text).to(equal("88.5"))
                }
                
                it("fills out the reps field with the given data on the delegate's set") {
                    expect(subject.repsEntryInputField?.text).to(equal("7"))
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
                            subject.weightEntryInputField?.text = "155.5"
                            subject.repsEntryInputField?.text = "8"
                            formData = subject.enteredLiftData
                        }
                        
                        it("returns a dictionary containing the data from the weight field") {
                            expect(formData?["weight"] as? Double).to(equal(155.5))
                        }
                        
                        it("returns a dictionary containing the data from the reps field") {
                            expect(formData?["reps"] as? Int).to(equal(8))
                        }
                    }
                    
                    describe("The validity of the form") {
                        context("When all the form's fields are filled out") {
                            beforeEach {
                                subject.weightEntryInputField?.text = "123"
                                subject.repsEntryInputField?.text = "10"
                            }
                            
                            it("considers the form valid") {
                                expect(subject.isFormValid).to(beTrue())
                            }
                        }
                        
                        context("When not all of the form's fields are filled out") {
                            beforeEach {
                                subject.weightEntryInputField?.text = "123"
                                subject.repsEntryInputField?.text = ""
                            }
                            
                            it("does not consider the form valid") {
                                expect(subject.isFormValid).to(beFalse())
                            }
                        }
                    }
                    
                    describe("Clearing focus from fields") {
                        context("When weight field is focused") {
                            beforeEach {
                                subject.weightEntryInputField?.becomeFirstResponder()
                                subject.removeCursorFromFields()
                            }
                            
                            it("unfocuses the weight field") {
                                expect(subject.weightEntryInputField?.isFirstResponder()).to(beFalse())
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
                    describe("When the weight text field is edited") {
                        beforeEach {
                            subject.weightEntryInputField?.sendActionsForControlEvents(.EditingChanged)
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
