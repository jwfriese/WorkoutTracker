import Quick
import Nimble
@testable import WorkoutTracker

class LiftTemplatePickerViewModelSpec: QuickSpec {

        class MockLiftTemplatePickerViewModelDelegate: LiftTemplatePickerViewModelDelegate {
                var selectedLiftDataTemplate: LiftDataTemplate?

                func didFinishSelectingLiftDataTemplate(liftDataTemplate: LiftDataTemplate) {
                        selectedLiftDataTemplate = liftDataTemplate
                }
        }

        override func spec() {
                describe("LiftTemplatePickerViewModel") {
                        var subject: LiftTemplatePickerViewModel!
                        var mockLiftTemplatePickerViewModelDelegate: MockLiftTemplatePickerViewModelDelegate!

                        beforeEach {
                                subject = LiftTemplatePickerViewModel()

                                mockLiftTemplatePickerViewModelDelegate = MockLiftTemplatePickerViewModelDelegate()
                                subject.delegate = mockLiftTemplatePickerViewModelDelegate
                        }

                        describe("After getting a picker view") {
                                var pickerView: UIPickerView!

                                beforeEach {
                                        pickerView = subject.dataTemplatePickerView
                                }

                                it("set itself as the picker view's delegate") {
                                        expect(pickerView.delegate).to(beIdenticalTo(subject))
                                }

                                it("set itself as the picker view's data source") {
                                        expect(pickerView.dataSource).to(beIdenticalTo(subject))
                                }
                                // given("set itself as the picker view's data source")
                                describe("As a UIPickerViewDataSource") {
                                        it("has one component") {
                                                expect(subject.numberOfComponentsInPickerView(pickerView)).to(equal(1))
                                        }

                                        it("has a row for each data template type") {
                                                expect(subject.pickerView(pickerView, numberOfRowsInComponent: 0)).to(equal(4))
                                        }
                                }

                                // given("set itself as the picker view's delegate")
                                describe("As a UIPickerViewDelegate") {
                                        it("sets the titles in the picker") {
                                                expect(subject.pickerView(pickerView, titleForRow: 0, forComponent: 0)).to(equal("Weight/Reps"))
                                                expect(subject.pickerView(pickerView, titleForRow: 1, forComponent: 0)).to(equal("Time(sec)"))
                                                expect(subject.pickerView(pickerView, titleForRow: 2, forComponent: 0)).to(equal("Weight/Time(sec)"))
                                                expect(subject.pickerView(pickerView, titleForRow: 3, forComponent: 0)).to(equal("Height/Reps"))
                                        }

                                        describe("Selection of an item in the picker") {
                                                // var selectedIndex = any(Int, from: 0, to: 3)
                                                let selectedIndex: Int = 1

                                                beforeEach {
                                                        subject.pickerView(pickerView, didSelectRow: selectedIndex, inComponent: 0)
                                                }

                                                it("passes the correct data template along to the delegate") {
                                                        expect(mockLiftTemplatePickerViewModelDelegate.selectedLiftDataTemplate).to(equal(LiftDataTemplate.TimeInSeconds))
                                                }
                                        }
                                }
                        }
                }
        }
}
