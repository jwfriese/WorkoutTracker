public protocol SetEditFormDelegate {
    var set: LiftSet? { get }
    func onFormChanged()
}
