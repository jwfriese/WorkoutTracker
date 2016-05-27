import Quick
import Nimble
@testable import WorkoutTracker
import Swinject

class LiftDataTemplateEntryViewControllerSpec: QuickSpec {
    override func spec() {
        class MockLiftDataTemplateEntryDelegate: LiftDataTemplateEntryDelegate {
            var selectedLiftDataTemplate: LiftDataTemplate?
            
            func didFinishSelectingLiftDataTemplate(liftDataTemplate: LiftDataTemplate) {
                selectedLiftDataTemplate = liftDataTemplate
            }
        }
        
        describe("LiftDataTemplateEntryViewController") {
            var subject: LiftDataTemplateEntryViewController!
            var mockLiftDataTemplateEntryDelegate: MockLiftDataTemplateEntryDelegate!
            
            beforeEach {
                let storyboardMetadata = WorkoutStoryboardMetadata()
                let container = Container()
                
                LiftDataTemplateEntryViewController.registerForInjection(container)
                
                let storyboard = SwinjectStoryboard.create(name: storyboardMetadata.name, bundle: nil, container: container)
                
                subject = storyboard.instantiateViewControllerWithIdentifier("LiftDataTemplateEntryViewController")
                    as! LiftDataTemplateEntryViewController
                
                mockLiftDataTemplateEntryDelegate = MockLiftDataTemplateEntryDelegate()
                subject.delegate = mockLiftDataTemplateEntryDelegate
            }
            
            describe("After the view has loaded") {
                var dataTemplatePickerView: UIPickerView?
                
                beforeEach {
                    TestAppDelegate.setAsRootViewController(subject)
                    dataTemplatePickerView = subject.dataTemplatePickerView
                }
                
                it("sets itself as the data source of its picker view") {
                    expect(dataTemplatePickerView!.dataSource).to(beIdenticalTo(subject))
                }
                
                it("sets itself as the delegate of its picker view") {
                    expect(dataTemplatePickerView!.delegate).to(beIdenticalTo(subject))
                }
                
                describe("As a UIPickerViewDataSource") {
                    it("has one component") {
                        expect(subject.numberOfComponentsInPickerView(dataTemplatePickerView!)).to(equal(1))
                    }
                    
                    it("has a row for each data template type") {
                        expect(subject.pickerView(dataTemplatePickerView!, numberOfRowsInComponent: 0)).to(equal(4))
                    }
                }
                
                // given("set itself as the picker view's delegate")
                describe("As a UIPickerViewDelegate") {
                    it("sets the titles in the picker") {
                        expect(subject.pickerView(dataTemplatePickerView!, titleForRow: 0, forComponent: 0)).to(equal("Weight/Reps"))
                        expect(subject.pickerView(dataTemplatePickerView!, titleForRow: 1, forComponent: 0)).to(equal("Time(sec)"))
                        expect(subject.pickerView(dataTemplatePickerView!, titleForRow: 2, forComponent: 0)).to(equal("Weight/Time(sec)"))
                        expect(subject.pickerView(dataTemplatePickerView!, titleForRow: 3, forComponent: 0)).to(equal("Height/Reps"))
                    }
                    
                    describe("Selection of an item in the picker") {
                        // var selectedIndex = any(Int, from: 0, to: 3)
                        let selectedIndex: Int = 1
                        
                        beforeEach {
                            subject.pickerView(dataTemplatePickerView!, didSelectRow: selectedIndex, inComponent: 0)
                        }
                        
                        it("passes the correct data template along to the delegate") {
                            expect(mockLiftDataTemplateEntryDelegate.selectedLiftDataTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                        }
                    }
                }
            }
        }
    }
}
