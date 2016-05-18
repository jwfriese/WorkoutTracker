import Quick
import Nimble
import Swinject
@testable import WorkoutTracker

class WorkoutStoryboardMetadataSpec: QuickSpec {
        override func spec() {
                describe("WorkoutStoryboardMetadata") {
                        var subject: WorkoutStoryboardMetadata!

                        beforeEach {
                                subject = WorkoutStoryboardMetadata()
                        }

                        it("has the correct name") {
                                expect(subject.name).to(equal("Workout"))
                        }

                        describe("The storyboard created using the metadata") {
                                var storyboard: SwinjectStoryboard!
                                var container: Container!

                                beforeEach {
                                        container = subject.container
                                        storyboard = SwinjectStoryboard.create(name: subject.name, bundle: nil, container: container)
                                }

                                describe("The container") {
                                        var workoutSaveAgent: WorkoutSaveAgent?
                                        var liftSaveAgent: LiftSaveAgent?
                                        var localStorageWorker: LocalStorageWorker?
                                        var workoutSerializer: WorkoutSerializer?
                                        var liftSerializer: LiftSerializer?
                                        var liftCreator: LiftCreator?
                                        var liftHistoryIndexLoader: LiftHistoryIndexLoader?
                                        var workoutLoadAgent: WorkoutLoadAgent?
                                        var liftLoadAgent: LiftLoadAgent?
                                        var workoutDeserializer: WorkoutDeserializer?
                                        var liftSetJSONValidator: LiftSetJSONValidator?
                                        var liftSetDeserializer: LiftSetDeserializer?
                                        var liftDeleteAgent: LiftDeleteAgent?
                                        var liftTableHeaderViewProvider: LiftTableHeaderViewProvider?
                                        var liftTemplatePickerViewModel: LiftTemplatePickerViewModel?
                                        var liftSetEditFormControllerFactory: LiftSetEditFormControllerFactory?
                                        var workoutViewController: WorkoutViewController?
                                        var liftViewController: LiftViewController?
                                        var liftEntryFormViewController: LiftEntryFormViewController?
                                        var setEditModalViewController: SetEditModalViewController?

                                        beforeEach {
                                                workoutSaveAgent = container.resolve(WorkoutSaveAgent.self)
                                                liftSaveAgent = container.resolve(LiftSaveAgent.self)
                                                localStorageWorker = container.resolve(LocalStorageWorker.self)
                                                workoutSerializer = container.resolve(WorkoutSerializer.self)
                                                liftSerializer = container.resolve(LiftSerializer.self)
                                                liftCreator = container.resolve(LiftCreator.self)
                                                liftHistoryIndexLoader = container.resolve(LiftHistoryIndexLoader.self)
                                                workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
                                                liftLoadAgent = container.resolve(LiftLoadAgent.self)
                                                workoutDeserializer = container.resolve(WorkoutDeserializer.self)
                                                liftSetJSONValidator = container.resolve(LiftSetJSONValidator.self)
                                                liftSetDeserializer = container.resolve(LiftSetDeserializer.self)
                                                liftDeleteAgent = container.resolve(LiftDeleteAgent.self)
                                                liftTableHeaderViewProvider = container.resolve(LiftTableHeaderViewProvider.self)
                                                liftTemplatePickerViewModel = container.resolve(LiftTemplatePickerViewModel.self)
                                                liftSetEditFormControllerFactory = container.resolve(LiftSetEditFormControllerFactory.self)

                                                workoutViewController = storyboard.instantiateViewControllerWithIdentifier("WorkoutViewController") as? WorkoutViewController
                                                liftViewController = storyboard.instantiateViewControllerWithIdentifier("LiftViewController") as? LiftViewController
                                                liftEntryFormViewController = storyboard.instantiateViewControllerWithIdentifier("LiftEntryFormViewController") as? LiftEntryFormViewController
                                                setEditModalViewController = storyboard.instantiateViewControllerWithIdentifier("SetEditModalViewController") as? SetEditModalViewController
                                        }

                                        it("can produce a WorkoutSaveAgent") {
                                                expect(workoutSaveAgent).toNot(beNil())
                                        }

                                        it("can produce a LiftSaveAgent") {
                                                expect(liftSaveAgent).toNot(beNil())
                                        }

                                        it("can produce a LocalStorageWorker") {
                                                expect(localStorageWorker).toNot(beNil())
                                        }

                                        it("can produce a WorkoutSerializer") {
                                                expect(workoutSerializer).toNot(beNil())
                                        }

                                        it("can produce a LiftSerializer") {
                                                expect(liftSerializer).toNot(beNil())
                                        }

                                        it("can produce a LiftCreator") {
                                                expect(liftCreator).toNot(beNil())
                                        }

                                        it("can produce a LiftHistoryIndexLoader") {
                                                expect(liftHistoryIndexLoader).toNot(beNil())
                                        }

                                        it("can produce a WorkoutLoadAgent") {
                                                expect(workoutLoadAgent).toNot(beNil())
                                        }

                                        it("can produce a LiftLoadAgent") {
                                                expect(liftLoadAgent).toNot(beNil())
                                        }

                                        it("can produce a WorkoutDeserializer") {
                                                expect(workoutDeserializer).toNot(beNil())
                                        }

                                        it("can produce a LiftSetJSONValidator") {
                                                expect(liftSetJSONValidator).toNot(beNil())
                                        }

                                        it("can produce a LiftSetDeserializer") {
                                                expect(liftSetDeserializer).toNot(beNil())
                                        }

                                        it("can produce a LiftDeleteAgent") {
                                                expect(liftDeleteAgent).toNot(beNil())
                                        }

                                        it("can produce a LiftTableHeaderViewProvider") {
                                                expect(liftTableHeaderViewProvider).toNot(beNil())
                                        }

                                        it("can produce a LiftTemplatePickerViewModel") {
                                                expect(liftTemplatePickerViewModel).toNot(beNil())
                                        }

                                        it("can produce a LiftSetEditFormControllerFactory") {
                                                expect(liftSetEditFormControllerFactory).toNot(beNil())
                                        }

                                        describe("Its WorkoutViewController") {
                                                it("can be created") {
                                                        expect(workoutViewController).toNot(beNil())
                                                }

                                                it("is created with a WorkoutSaveAgent") {
                                                        expect(workoutViewController?.workoutSaveAgent).toNot(beNil())
                                                }

                                                it("is created with a LiftCreator") {
                                                        expect(workoutViewController?.liftCreator).toNot(beNil())
                                                }

                                                it("is created with a LiftDeleteAgent") {
                                                        expect(workoutViewController?.liftDeleteAgent).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftViewController") {
                                                it("can be created") {
                                                        expect(liftViewController).toNot(beNil())
                                                }

                                                it("is created with a WorkoutSaveAgent") {
                                                        expect(liftViewController?.workoutSaveAgent).toNot(beNil())
                                                }

                                                it("is created with a LiftTableHeaderViewProvider") {
                                                        expect(liftViewController?.liftTableHeaderViewProvider).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftEntryFormViewController") {
                                                it("can be created") {
                                                        expect(liftEntryFormViewController).toNot(beNil())
                                                }

                                                it("is created with a LiftTemplatePickerViewModel") {
                                                        expect(liftEntryFormViewController?.liftTemplatePickerViewModel).toNot(beNil())
                                                }
                                        }

                                        describe("Its SetEditModalViewController") {
                                                it("can be created") {
                                                        expect(setEditModalViewController).toNot(beNil())
                                                }

                                                it("is created with a LiftSetEditFormControllerFactory") {
                                                        expect(setEditModalViewController?.liftSetEditFormControllerFactory).toNot(beNil())
                                                }
                                        }

                                        describe("Its WorkoutSaveAgent") {
                                                it("is created with a WorkoutSerializer") {
                                                        expect(workoutSaveAgent?.workoutSerializer).toNot(beNil())
                                                }

                                                it("is created with a LiftSaveAgent") {
                                                        expect(workoutSaveAgent?.liftSaveAgent).toNot(beNil())
                                                }

                                                it("is created with a LocalStorageWorker") {
                                                        expect(workoutSaveAgent?.localStorageWorker).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftSaveAgent") {
                                                it("is created with a LiftSerializer") {
                                                        expect(liftSaveAgent?.liftSerializer).toNot(beNil())
                                                }

                                                it("is created with a LocalStorageWorker") {
                                                        expect(liftSaveAgent?.localStorageWorker).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftCreator") {
                                                it("is created with a LiftLoadAgent") {
                                                        expect(liftCreator?.liftLoadAgent).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftHistoryIndexLoader") {
                                                it("is created with a LocalStorageWorker") {
                                                        expect(liftHistoryIndexLoader?.localStorageWorker).toNot(beNil())
                                                }
                                        }

                                        describe("Its WorkoutLoadAgent") {
                                                it("is created with a WorkoutDeserializer") {
                                                        expect(workoutLoadAgent?.workoutDeserializer).toNot(beNil())
                                                }

                                                it("is created with a LocalStorageWorker") {
                                                        expect(workoutLoadAgent?.localStorageWorker).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftLoadAgent") {
                                                it("is created with a LiftSetDeserializer") {
                                                        expect(liftLoadAgent?.liftSetDeserializer).toNot(beNil())
                                                }

                                                it("is created with a LocalStorageWorker") {
                                                        expect(liftLoadAgent?.localStorageWorker).toNot(beNil())
                                                }

                                                it("is created with a LiftHistoryIndexLoader") {
                                                        expect(liftLoadAgent?.liftHistoryIndexLoader).toNot(beNil())
                                                }
                                        }

                                        describe("Its WorkoutDeserializer") {
                                                it("is created with a LiftLoadAgent") {
                                                        expect(workoutDeserializer?.liftLoadAgent).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftSetDeserializer") {
                                                it("is created with a LiftSetJSONValidator") {
                                                        expect(liftSetDeserializer?.liftSetJSONValidator).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftDeleteAgent") {
                                                it("is created with a LocalStorageWorker") {
                                                        expect(liftDeleteAgent?.localStorageWorker).toNot(beNil())
                                                }
                                        }

                                        describe("Its LiftSetEditFormControllerFactory") {
                                                it("is created with this as its controller container") {
                                                        expect(liftSetEditFormControllerFactory?.controllerContainer).to(beIdenticalTo(container))
                                                }
                                        }
                                }

                                describe("The initial view controller") {
                                        var initialViewController: WorkoutViewController?

                                        beforeEach {
                                                initialViewController = subject.initialViewController as? WorkoutViewController
                                        }

                                        it("is a WorkoutViewController") {
                                                expect(initialViewController).toNot(beNil())
                                        }

                                        it("is created with a WorkoutSaveAgent") {
                                                expect(initialViewController?.workoutSaveAgent).toNot(beNil())
                                        }

                                        it("is created with a LiftCreator") {
                                                expect(initialViewController?.liftCreator).toNot(beNil())
                                        }

                                        it("is created with a LiftDeleteAgent") {
                                                expect(initialViewController?.liftDeleteAgent).toNot(beNil())
                                        }
                                }

//                                describe("Injecting dependencies into instances") {
//                                        describe("For a LiftEntryFormViewController") {
//                                                var liftEntryFormViewController: LiftEntryFormViewController!
//
//                                                beforeEach {
//                                                        liftEntryFormViewController = LiftEntryFormViewController()
//                                                        subject.injectDependencies(liftEntryFormViewController)
//                                                }
//
//                                                it("sets its LiftTemplatePickerViewModel") {
//                                                        expect(liftEntryFormViewController.liftTemplatePickerViewModel).toNot(beNil())
//                                                }
//                                        }
//                                }
                        }
                }
        }
}
