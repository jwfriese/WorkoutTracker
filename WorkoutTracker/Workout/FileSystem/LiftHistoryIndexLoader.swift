import Foundation

public class LiftHistoryIndexLoader {
    public var localStorageWorker: LocalStorageWorker!
    
    public init(withLocalStorageWorker localStorageWorker: LocalStorageWorker?) {
        self.localStorageWorker = localStorageWorker
    }
    
    public func load() -> [String: [UInt]] {
        return localStorageWorker.readJSONDictionaryFromFile("Indices/LiftHistory.json") as! [String : [UInt]]
    }
}
