import Swinject

protocol Injectable {
    static func registerForInjection(container: Container)
}
