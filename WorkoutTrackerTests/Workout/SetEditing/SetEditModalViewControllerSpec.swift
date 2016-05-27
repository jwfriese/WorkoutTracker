import Quick
import Nimble
import Fleet
import Swinject
@testable import WorkoutTracker

class SetEditModalViewControllerSpec: QuickSpec {
    override func spec() {
        class MockLiftSetEditFormControllerImpl: LiftSetEditFormController {
            var testEnteredLiftData = [String : AnyObject]()
            var isTestFormValid: Bool = false
            var testDelegate: SetEditFormDelegate?
            private(set) var didRemoveCursorFocus: Bool = false
            
            init() {}
            
            var form: UIView? = UIView()
            
            var enteredLiftData: [String : AnyObject] {
                get {
                    return testEnteredLiftData
                }
            }
            
            var isFormValid: Bool {
                get {
                    return isTestFormValid
                }
            }
            
            var delegate: SetEditFormDelegate? {
                get {
                    return testDelegate
                }
                
                set {
                    testDelegate = newValue
                }
            }
            
            func removeCursorFromFields() {
                didRemoveCursorFocus = true
            }
        }
        
        class MockLiftSetEditFormControllerFactory: LiftSetEditFormControllerFactory {
            var capturedTemplate: LiftDataTemplate?
            var controller: MockLiftSetEditFormControllerImpl!
            
            override private func controllerForTemplate(template: LiftDataTemplate) -> LiftSetEditFormController? {
                capturedTemplate = template
                
                return controller
            }
        }
        
        class MockSetEditDelegate: SetEditDelegate {
            var enteredData: [String : AnyObject]?
            var internalLastSetEntered: LiftSet?
            var canceled: Bool = false
            
            var liftDataTemplate: LiftDataTemplate {
                get {
                    return .HeightReps
                }
            }
            
            var lastSetEntered: LiftSet? {
                get {
                    return internalLastSetEntered
                }
                set {
                    internalLastSetEntered = newValue
                }
            }
            
            func setEnteredWithData(data: [String : AnyObject]) {
                enteredData = data
            }
            
            func editCanceled() {
                canceled = true
            }
        }
        
        describe("SetEditModalViewController") {
            var subject: SetEditModalViewController!
            var mockLiftSetEditFormControllerFactory: MockLiftSetEditFormControllerFactory!
            var mockLiftSetEditFormController: MockLiftSetEditFormControllerImpl!
            var mockSetEditDelegate: MockSetEditDelegate!
            
            beforeEach {
                mockLiftSetEditFormControllerFactory = MockLiftSetEditFormControllerFactory()
                mockLiftSetEditFormController = MockLiftSetEditFormControllerImpl()
                mockLiftSetEditFormControllerFactory.controller = mockLiftSetEditFormController
                
                let storyboardMetadata = WorkoutStoryboardMetadata()
                
                let container = Container()
                container.register(LiftSetEditFormControllerFactory.self) { resolver in
                    return mockLiftSetEditFormControllerFactory
                }
                
                SetEditModalViewController.registerForInjection(container)
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil,
                    container: container)
                subject = storyboard.instantiateViewControllerWithIdentifier("SetEditModalViewController")
                    as! SetEditModalViewController
                
                mockSetEditDelegate = MockSetEditDelegate()
                subject.delegate = mockSetEditDelegate
            }
            
            describe("Injection of its dependencies") {
                it("sets a LiftSetEditFormControllerFactory on the view controller") {
                    expect(subject.liftSetEditFormControllerFactory).to(beIdenticalTo(mockLiftSetEditFormControllerFactory))
                }
            }
            
            describe("After the view has loaded") {
                sharedExamples("Editing and committing changes to the set") {
                    it("adjusts the width and color of its border") {
                        expect(subject.contentView?.layer.borderWidth).to(equal(2.0))
                        
                        let colorsEqual = CGColorEqualToColor(subject.contentView?.layer.borderColor,
                                                              UIColor.grayColor().CGColor)
                        expect(colorsEqual).to(beTruthy())
                    }
                    
                    describe("Availability of the form submit button") {
                        context("When the form is not in a valid state") {
                            beforeEach {
                                mockLiftSetEditFormController.isTestFormValid = false
                                subject.onFormChanged()
                            }
                            
                            it("disables the form submit button") {
                                expect(subject.formSubmitButton?.enabled).to(beFalse())
                            }
                        }
                        
                        context("When the form is in a valid state") {
                            beforeEach {
                                mockLiftSetEditFormController.isTestFormValid = true
                                subject.onFormChanged()
                            }
                            
                            it("enables the submit button") {
                                expect(subject.formSubmitButton?.enabled).to(beTrue())
                            }
                        }
                    }
                    
                    it("attaches a tap gesture recognizer to the background view") {
                        expect(subject.tapGestureRecognizer?.view).to(beIdenticalTo(subject.backgroundView))
                    }
                    
                    describe("Entering form data and submitting") {
                        beforeEach {
                            mockLiftSetEditFormController.testEnteredLiftData = ["turtle_strength": 9002]
                            subject.formSubmitButton?.tap()
                        }
                        
                        it("passes the form data along to its delegate") {
                            expect(mockSetEditDelegate.enteredData?["turtle_strength"] as? Int).to(equal(9002))
                        }
                    }
                }
                
                context("A set is already set on the controller") {
                    var set: LiftSet!
                    
                    beforeEach {
                        set = LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtle_power": 9000])
                        subject.set = set
                        TestAppDelegate.setAsRootViewController(subject)
                    }
                    
                    it("sets the form submit button's text to 'Save'") {
                        expect(subject.formSubmitButton?.titleLabel?.text).to(equal("Save"))
                    }
                    
                    it("passes the lift set's data template along to the factory") {
                        expect(mockLiftSetEditFormControllerFactory.capturedTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                    }
                    
                    it("sets itself as the delegate for the form controller") {
                        if let delegate = mockLiftSetEditFormController.delegate as? SetEditModalViewController {
                            expect(delegate).to(beIdenticalTo(subject))
                        } else {
                            fail("Expected subject to be delegate of form controller")
                        }
                    }
                    
                    it("sets the form controller's view as a subview of the form container") {
                        expect(subject.formContainerView?.subviews).to(contain(mockLiftSetEditFormController.form))
                    }
                    
                    it("does not focus the cursor in either text field") {
                        expect(mockLiftSetEditFormController.didRemoveCursorFocus).to(beTrue())
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
                        
                        it("passes the delegate's data template along to the factory") {
                            expect(mockLiftSetEditFormControllerFactory.capturedTemplate).to(equal(LiftDataTemplate.HeightReps))
                        }
                        
                        it("sets itself as the delegate for the form controller") {
                            if let delegate = mockLiftSetEditFormController.delegate as? SetEditModalViewController {
                                expect(delegate).to(beIdenticalTo(subject))
                            } else {
                                fail("Expected subject to be delegate of form controller")
                            }
                        }
                        
                        it("sets the form controller's view as a subview of the form container") {
                            expect(subject.formContainerView?.subviews).to(contain(mockLiftSetEditFormController.form))
                        }
                        
                        it("disables the form submit button") {
                            expect(subject.formSubmitButton?.enabled).to(beFalse())
                        }
                        
                        itBehavesLike("Editing and committing changes to the set")
                    }
                    
                    context("The delegate has a previous set") {
                        beforeEach {
                            let previousSet = LiftSet(withDataTemplate: .TimeInSeconds, data: ["turtle_power_level": 9001])
                            mockSetEditDelegate.internalLastSetEntered = previousSet
                            TestAppDelegate.setAsRootViewController(subject)
                        }
                        
                        it("shows the 'Add Previous' button") {
                            expect(subject.addPreviousButton?.hidden).to(beFalse())
                        }
                        
                        describe("Tapping the 'Add Previous' button") {
                            beforeEach {
                                subject.addPreviousButton?.tap()
                            }
                            
                            it("passes the form data along to its delegate") {
                                expect(mockSetEditDelegate.enteredData?["turtle_power_level"] as? Int).to(equal(9001))
                            }
                        }
                        
                        itBehavesLike("A set is not yet on the controller")
                    }
                    
                    context("The delegate does not have a previous set") {
                        beforeEach {
                            mockSetEditDelegate.internalLastSetEntered = nil
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
                        expect(mockSetEditDelegate.canceled).to(beTrue())
                    }
                }
            }
        }
    }
}
