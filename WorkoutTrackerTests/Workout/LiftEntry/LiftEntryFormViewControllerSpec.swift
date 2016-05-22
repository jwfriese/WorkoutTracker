import Quick
import Nimble
import Fleet
import Swinject
@testable import WorkoutTracker

class LiftEntryFormViewControllerSpec: QuickSpec {
    override func spec() {
        
        class MockLiftEntryFormDelegate: LiftEntryFormDelegate {
            var enteredName: String?
            var enteredLiftDataTemplate: LiftDataTemplate?
            
            func liftEnteredWithName(name: String, dataTemplate: LiftDataTemplate) {
                enteredName = name
                enteredLiftDataTemplate = dataTemplate
            }
        }
        
        describe("LiftEntryFormViewController") {
            var subject: LiftEntryFormViewController!
            var mockLiftEntryFormDelegate: MockLiftEntryFormDelegate!
            
            beforeEach {
                mockLiftEntryFormDelegate = MockLiftEntryFormDelegate()
                
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let container = storyboardMetadata.container
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil,
                    container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("LiftEntryFormViewController")
                    as! LiftEntryFormViewController
                
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
                
                it("shows the data selection view") {
                    expect(subject.selectView?.hidden).to(beFalse())
                }
                
                it("hides the data display view") {
                    expect(subject.displaySelectionView?.hidden).to(beTrue())
                }
                
                describe("Tapping the 'Select' button") {
                    beforeEach {
                        subject.selectDataButton?.tap()
                    }
                    
                    it("shows the lift data template picker") {
                        expect(subject.presentedViewController).to(beAnInstanceOf(LiftDataTemplateEntryViewController.self))
                    }
                    
                    it("sets itself as the lift data template entry controller's delegate") {
                        let liftDataTemplateEntryViewController = subject.presentedViewController as? LiftDataTemplateEntryViewController
                        expect(liftDataTemplateEntryViewController?.delegate).to(beIdenticalTo(subject))
                    }
                    
                    // given("shows the lift data template picker", "sets itself as the lift data template picker's delegate")
                    describe("When selection of a data template completes") {
                        sharedExamples("The entry form when data template is selected") {
                            it("hides the data selection view") {
                                expect(subject.selectView?.hidden).to(beTrue())
                            }
                            
                            it("shows the data display view") {
                                expect(subject.displaySelectionView?.hidden).to(beFalse())
                            }
                        }
                        
                        context("For weight/reps data template") {
                            beforeEach {
                                subject.didFinishSelectingLiftDataTemplate(.WeightReps)
                            }
                            
                            itBehavesLike("The entry form when data template is selected")
                            
                            it("displays 'Weight/Reps' for the template info description") {
                                expect(subject.displaySelectionLabel?.text).to(equal("Weight/Reps"))
                            }
                        }
                        
                        context("For time in seconds data template") {
                            beforeEach {
                                subject.didFinishSelectingLiftDataTemplate(.TimeInSeconds)
                            }
                            
                            itBehavesLike("The entry form when data template is selected")
                            
                            it("displays 'Time(sec)' for the template info description") {
                                expect(subject.displaySelectionLabel?.text).to(equal("Time(sec)"))
                            }
                        }
                        
                        context("For weight/time in seconds data template") {
                            beforeEach {
                                subject.didFinishSelectingLiftDataTemplate(.WeightTimeInSeconds)
                            }
                            
                            itBehavesLike("The entry form when data template is selected")
                            
                            it("displays 'Weight/Time(sec)' for the template info description") {
                                expect(subject.displaySelectionLabel?.text).to(equal("Weight/Time(sec)"))
                            }
                        }
                        
                        context("For height/reps data template") {
                            beforeEach {
                                subject.didFinishSelectingLiftDataTemplate(.HeightReps)
                            }
                            
                            itBehavesLike("The entry form when data template is selected")
                            
                            it("displays 'Height/Reps' for the template info description") {
                                expect(subject.displaySelectionLabel?.text).to(equal("Height/Reps"))
                            }
                        }
                        
                        describe("Tapping on the 'Change' button once a selection has been made") {
                            // var anyDataTemplate = any(LiftDataTemplate)
                            let anyDataTemplate: LiftDataTemplate = .WeightReps
                            
                            beforeEach {
                                subject.didFinishSelectingLiftDataTemplate(anyDataTemplate)
                                subject.changeSelectionButton?.tap()
                            }
                            
                            it("shows the lift data template picker") {
                                expect(subject.presentedViewController).to(beAnInstanceOf(LiftDataTemplateEntryViewController.self))
                            }
                            
                            it("sets itself as the lift data template entry controller's delegate") {
                                let liftDataTemplateEntryViewController = subject.presentedViewController as? LiftDataTemplateEntryViewController
                                expect(liftDataTemplateEntryViewController?.delegate).to(beIdenticalTo(subject))
                            }
                        }
                    }
                }
                
                describe("Availability of the 'Create' button") {
                    context("When text field is empty and no data template selected") {
                        beforeEach {
                            subject.nameEntryInputField?.text = ""
                            subject.nameEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("disables the 'Create' button") {
                            expect(subject.createButton?.enabled).to(beFalse())
                        }
                    }
                    
                    context("When text field has any nonwhitespace text in it and no data template selected") {
                        beforeEach {
                            subject.nameEntryInputField?.text = "¬˚∆˙©©"
                            subject.nameEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                        }
                        
                        it("disables the 'Create' button") {
                            expect(subject.createButton?.enabled).to(beFalse())
                        }
                    }
                    
                    context("When text field has any nonwhitespace text in it and data template selected") {
                        beforeEach {
                            subject.nameEntryInputField?.text = "∑"
                            subject.nameEntryInputField?.sendActionsForControlEvents(.EditingChanged)
                            subject.didFinishSelectingLiftDataTemplate(.HeightReps)
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
                        subject.didFinishSelectingLiftDataTemplate(.HeightReps)
                        subject.createButton?.tap()
                    }
                    
                    it("passes the form data along to its delegate") {
                        expect(mockLiftEntryFormDelegate.enteredName).to(equal("turtle grace"))
                        expect(mockLiftEntryFormDelegate.enteredLiftDataTemplate).to(equal(LiftDataTemplate.HeightReps))
                    }
                }
            }
        }
    }
}
