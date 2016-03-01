import UIKit

let appDelegateName = NSBundle.mainBundle().objectForInfoDictionaryKey("APP_DELEGATE_NAME") as! String
UIApplicationMain(Process.argc, Process.unsafeArgv, nil, appDelegateName)
