import Foundation

class LiftHistoryIndexLoader {
    var localStorageWorker: LocalStorageWorker!
    
    init(withLocalStorageWorker localStorageWorker: LocalStorageWorker?) {
        self.localStorageWorker = localStorageWorker
    }
    
    func load() -> [String: [UInt]] {
        return localStorageWorker.readJSONDictionaryFromFile("Indices/LiftHistory.json") as! [String : [UInt]]
    }
}
