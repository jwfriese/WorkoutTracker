import Quick
import Nimble
@testable import WorkoutTracker
import Swinject

class WeightTimeInSecondsEditFormViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockSetEditFormDelegate: SetEditFormDelegate {
            var didFormChange: Bool = false
            var set: LiftSet? {
                get {
                    return LiftSet(withDataTemplate: .WeightTimeInSeconds, data: ["weight": 88.5, "time(sec)": 7])
                }
            }
            
            func onFormChanged() {
                didFormChange = true
            }
        }
        
        describe("WeightTimeInSecondsEditFormViewController") {
            var subject: WeightTimeInSecondsEditFormViewController!
            var container: Container!
            var mockSetEditFormDelegate: MockSetEditFormDelegate!
            
            beforeEach {
                container = Container()
                
                WeightTimeInSecondsEditFormViewController.registerForInjection(container)
                
                subject = container.resolve(WeightTimeInSecondsEditFormViewController.self)
                
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
                
                it("fills out the time in seconds field with the given data on the delegate's set") {
                    expect(subject.timeInSecondsEntryInputField?.text).to(equal("7"))
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
                            subject.timeInSecondsEntryInputField?.text = "8"
                            formData = subject.enteredLiftData
                        }
                        
                        it("returns a dictionary containing the data from the weight field") {
                            expect(formData?["weight"] as? Double).to(equal(155.5))
                        }
                        
                        it("returns a dictionary containing the data from the time in seconds field") {
                            expect(formData?["time(sec)"] as? Int).to(equal(8))
                        }
                    }
                    
                    describe("The validity of the form") {
                        context("When all the form's fields are filled out") {
                            beforeEach {
                                subject.weightEntryInputField?.text = "123"
                                subject.timeInSecondsEntryInputField?.text = "10"
                            }
                            
                            it("considers the form valid") {
                                expect(subject.isFormValid).to(beTrue())
                            }
                        }
                        
                        context("When not all of the form's fields are filled out") {
                            beforeEach {
                                subject.weightEntryInputField?.text = "123"
                                subject.timeInSecondsEntryInputField?.text = ""
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
                        
                        context("When time in seconds field is focused") {
                            beforeEach {
                                subject.timeInSecondsEntryInputField?.becomeFirstResponder()
                                subject.removeCursorFromFields()
                            }
                            
                            it("unfocuses the time in seconds field") {
                                expect(subject.timeInSecondsEntryInputField?.isFirstResponder()).to(beFalse())
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
                    
                    describe("When the time in seconds text field is edited") {
                        beforeEach {
                            subject.timeInSecondsEntryInputField?.sendActionsForControlEvents(.EditingChanged)
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
