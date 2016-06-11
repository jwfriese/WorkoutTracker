import Foundation
import Swinject

class TimeFormatter {
    func sqlTimestamptzStringFromIntegerTimestamp(timestamp: UInt) -> String {
        let date = NSDate(timeIntervalSince1970: Double(timestamp))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func integerTimestampFromSqlTimestamptzString(timestamptzString: String) -> UInt? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        let date = dateFormatter.dateFromString(timestamptzString)
        if let date = date  {
            return UInt(date.timeIntervalSince1970)
        }
        
        return nil
    }
}

extension TimeFormatter: Injectable {
    static func registerForInjection(container: Container) {
        container.register(TimeFormatter.self) { _ in
            return TimeFormatter()
        }
    }
}
