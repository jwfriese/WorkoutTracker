import Foundation
import UIKit
import Swinject

class LocalStorageWorker {
    func writeData(data: NSData!, toFileWithName name: String!, createSubdirectories: Bool = false) throws {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let pathComponents = name.characters.split("/")
            var currentDirectory = ""
            for (index, pathComponent) in pathComponents.enumerate() {
                if index != (pathComponents.count - 1) {
                    currentDirectory += String(pathComponent)
                    let subdirectoryFullPath = documentsDirectoryPath + "/" + String(currentDirectory)
                    if !NSFileManager.defaultManager().fileExistsAtPath(subdirectoryFullPath) {
                        if createSubdirectories {
                            createDirectory(currentDirectory)
                        } else {
                            throw NSError(domain: NSGenericException, code: NSFileNoSuchFileError, userInfo: nil)
                        }
                    }
                    currentDirectory += "/"
                }
            }
            
            let writeDataPathName = documentsDirectoryPath.stringByAppendingString("/" + name)
            data.writeToFile(writeDataPathName, atomically: true)
        }
    }
    
    func writeJSONDictionary(dictionary: Dictionary<String, AnyObject>, toFileWithName name: String!,
                             createSubdirectories: Bool = false) throws {
        let dictionaryData: NSData?
        dictionaryData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: .PrettyPrinted)
        try writeData(dictionaryData!, toFileWithName: name, createSubdirectories: createSubdirectories)
    }
    
    func writeImage(image: UIImage!, toFileWithName name: String!, createSubdirectories: Bool = false) throws {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        try self.writeData(imageData, toFileWithName: name, createSubdirectories: createSubdirectories)
    }
    
    func readDataFromFile(fileName: String!) -> NSData? {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let dataFilePathName = documentsDirectoryPath.stringByAppendingString("/" + fileName)
            return NSData(contentsOfFile: dataFilePathName)
        }
        
        return nil
    }
    
    func readJSONDictionaryFromFile(fileName: String!) -> Dictionary<String, AnyObject>? {
        let fetchedData = readDataFromFile(fileName)
        let fetchedDictionary = try! NSJSONSerialization.JSONObjectWithData(fetchedData!, options: .AllowFragments) as? [String : AnyObject]
        return fetchedDictionary
    }
    
    func readImageFromFile(fileName: String!) -> UIImage? {
        if let imageData = readDataFromFile(fileName) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
    
    func createDirectory(directoryName: String) -> Bool {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let newDirectoryPath = documentsDirectoryPath + "/" + directoryName
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(newDirectoryPath, withIntermediateDirectories: false, attributes: nil)
                return true
            } catch let error as NSError {
                print(error.localizedDescription)
                return false
            }
        }
        
        return false
    }
    
    func allFilesWithExtension(ext: String!, recursive: Bool,
                               startingDirectory: String = "") -> [String] {
        var fileNames = [String]()
        
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            var startingSubcomponent = ""
            if startingDirectory != "" {
                startingSubcomponent += (startingDirectory + "/")
            }
            
            let startingDirectoryPath = documentsDirectoryPath + "/" + startingSubcomponent
            let documentsEnumerator = NSFileManager.defaultManager().enumeratorAtPath(startingDirectoryPath)
            while let fileItem = documentsEnumerator?.nextObject() as? String {
                let fullFilePath = startingDirectoryPath + "/" + fileItem
                var isDirectory: ObjCBool = false
                NSFileManager.defaultManager().fileExistsAtPath(fullFilePath,
                                                                isDirectory: &isDirectory)
                if isDirectory.boolValue {
                    if !recursive {
                        documentsEnumerator?.skipDescendants()
                    }
                } else {
                    if (fileItem.hasSuffix(ext)) {
                        fileNames.append(startingSubcomponent + fileItem)
                    }
                }
            }
        }
        
        return fileNames
    }
    
    func deleteFile(fileName: String!) throws {
        let filePaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if filePaths.count > 0 {
            let documentsDirectoryPath = filePaths[0]
            let dataFilePathName = documentsDirectoryPath.stringByAppendingString("/" + fileName)
            try! NSFileManager.defaultManager().removeItemAtPath(dataFilePathName)
        }
    }
    
    func deleteAllFilesWithExtension(ext: String!, recursive: Bool,
                                     startingDirectory: String = "") throws {
        for file in self.allFilesWithExtension(ext, recursive: recursive, startingDirectory: startingDirectory) {
            try self.deleteFile(file)
        }
    }
}

extension LocalStorageWorker: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LocalStorageWorker.self) { _ in return LocalStorageWorker() }
    }
}
