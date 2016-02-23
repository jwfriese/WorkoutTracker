import Foundation
import UIKit

public class LocalStorageWorker {
    public init() { }
    
    public func writeData(data: NSData!, toFileWithName name: String!) {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let writeDataPathName = documentsDirectoryPath.stringByAppendingString("/" + name)
            data.writeToFile(writeDataPathName, atomically: true)
        }
    }
    
    public func writeImage(image: UIImage!, toFileWithName name: String!) {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        self.writeData(imageData, toFileWithName: name)
    }
    
    public func readDataFromFile(fileName: String!) -> NSData? {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let dataFilePathName = documentsDirectoryPath.stringByAppendingString("/" + fileName)
            return NSData(contentsOfFile: dataFilePathName)
        }
        
        return nil
    }
    
    public func readImageFromFile(fileName: String!) -> UIImage? {
        if let imageData = readDataFromFile(fileName) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
    
    public func allFilesWithExtension(ext: String!) -> [String] {
        var fileNames = [String]()
        
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let documentsEnumerator = NSFileManager.defaultManager().enumeratorAtPath(documentsDirectoryPath)
            while let fileName = documentsEnumerator?.nextObject() as? String {
                if (fileName.hasSuffix(ext)) {
                    fileNames.append(fileName)
                }
            }
        }
        
        return fileNames
    }
    
    public func deleteFile(fileName: String!) throws {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let dataFilePathName = documentsDirectoryPath.stringByAppendingString("/" + fileName)
            try! NSFileManager.defaultManager().removeItemAtPath(dataFilePathName)
        }
    }
    
    public func deleteAllFilesWithExtension(ext: String!) throws {
        for file in self.allFilesWithExtension(ext) {
            try! self.deleteFile(file)
        }
    }
}
