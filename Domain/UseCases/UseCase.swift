import Foundation
import RxSwift

public protocol UseCase {
    associatedtype I
    associatedtype S
    associatedtype O
    static func assemble(input: I, service: S, output: O) -> Disposable
}
