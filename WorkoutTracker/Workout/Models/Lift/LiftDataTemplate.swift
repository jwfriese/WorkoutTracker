enum LiftDataTemplate: String {
    case WeightReps = "Weight/Reps"
    case TimeInSeconds = "Time(sec)"
    case WeightTimeInSeconds = "Weight/Time(sec)"
    case HeightReps = "Height/Reps"
    
    static var allValues: [LiftDataTemplate] {
        get {
            return [.WeightReps, .TimeInSeconds, .WeightTimeInSeconds, .HeightReps]
        }
    }
}
