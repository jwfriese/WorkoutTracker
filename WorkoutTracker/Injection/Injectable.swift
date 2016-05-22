import Swinject

public protocol Injectable {
        static func registerForInjection(container: Container)
}
