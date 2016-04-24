import Foundation

public enum Result<T> {
    case Success(T)
    case Error(ErrorType)
}

public protocol Squaring {
    func square<T: IntegerArithmeticType>(number: T) -> T
}

public class SquaringCounter: Squaring {

    public var runCount = 0

    public func square<T: IntegerArithmeticType>(number: T) -> T {
        runCount += 1
        return number * number
    }

    public init() {
    }

}
