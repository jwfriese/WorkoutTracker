import Foundation
import Swinject

class LiftHistoryIndexLoader {
    var localStorageWorker: LocalStorageWorker!
    
    func load() -> [String: [UInt]] {
        return localStorageWorker.readJSONDictionaryFromFile("Indices/LiftHistory.json") as! [String : [UInt]]
    }
}

extension LiftHistoryIndexLoader: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftHistoryIndexLoader.self) { resolver in
            let instance = LiftHistoryIndexLoader()
            
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
