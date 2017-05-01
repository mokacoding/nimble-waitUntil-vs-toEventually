import Foundation

func onBackgroudWithDelay(_ delay: Double = 0.1, execute closure: @escaping () -> ()) {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

enum Result<T> {
    case success(T)
    case error(Error)
}

protocol AsynServiceDelegate: class {
    var aProperty: String { get set }
}

class AsyncService {

    func doStuff(_ completion: @escaping (Result<String>) -> ()) {
        onBackgroudWithDelay {
            completion(Result<String>.success("banzinga"))
        }
    }

    // MARK: -

    weak var delegate: AsynServiceDelegate?

    func callThatResultsInSideEffect() {
        onBackgroudWithDelay { [weak self] in
            self?.delegate?.aProperty = "bazinga"
        }
    }
}
