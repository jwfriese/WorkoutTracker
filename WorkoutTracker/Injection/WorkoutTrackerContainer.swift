import Swinject

class WorkoutTrackerContainer {
    static var container = WorkoutTrackerContainer.createContainer()
    
    private static func createContainer() -> Container {
        let container = SwinjectStoryboard.defaultContainer
        
        LocalStorageWorker.registerForInjection(container)
        WorkoutSerializer.registerForInjection(container)
        LiftSerializer.registerForInjection(container)
        LiftCreator.registerForInjection(container)
        LiftHistoryIndexLoader.registerForInjection(container)
        LiftSaveAgent.registerForInjection(container)
        WorkoutSaveAgent.registerForInjection(container)
        WorkoutLoadAgent.registerForInjection(container)
        LiftLoadAgent.registerForInjection(container)
        LiftHistoryIndexLoader.registerForInjection(container)
        WorkoutDeserializer.registerForInjection(container)
        LiftSetJSONValidator.registerForInjection(container)
        LiftSetDeserializer.registerForInjection(container)
        LiftDeleteAgent.registerForInjection(container)
        LiftTableHeaderViewProvider.registerForInjection(container)
        LiftSetEditFormControllerFactory.registerForInjection(container)
        Timestamper.registerForInjection(container)
        TimeFormatter.registerForInjection(container)
        WorkoutDeleteAgent.registerForInjection(container)
        MigrationAgent.registerForInjection(container)
        LiftHistoryIndexBuilder.registerForInjection(container)
        
        StartupViewController.registerForInjection(container)
        LiftEntryFormViewController.registerForInjection(container)
        WorkoutViewController.registerForInjection(container)
        LiftViewController.registerForInjection(container)
        SetEditModalViewController.registerForInjection(container)
        WorkoutListViewController.registerForInjection(container)
        
        return container
    }
}
