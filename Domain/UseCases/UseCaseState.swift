import Foundation

public struct Empty: Equatable {
    public static func == (lhs: Empty, rhs: Empty) -> Bool {
        return true
    }
}

public enum UseCaseState<T: Equatable>: Equatable{
    case inProgress
    case succeeded(T)
    case failed(Error)

    public static func ==(lhs: UseCaseState, rhs: UseCaseState) -> Bool {
        switch (lhs, rhs) {
        case (.inProgress, .inProgress):
            return true
        case (.succeeded(let lhsValue), .succeeded(let rhsValue)):
            return lhsValue == rhsValue
        case (.failed(let lhsError), .failed(let rhsError)):
            if (lhsError as AnyObject) === (rhsError as AnyObject) {
                return true
            }
            if (lhsError as NSError) == (rhsError as NSError) {
                return true
            }
            return false
        default:
            return false
        }
    }
}
