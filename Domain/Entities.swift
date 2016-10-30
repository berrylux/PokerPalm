
import Foundation
import RxSwift

public protocol Identifiable {
    var ID: UUID { get }
}

open class AbstractRepository<T> {
    func query(with predicate: NSPredicate) -> Observable<[T]> {
        fatalError("Should")
    }
    func queryFirst(with predicate: NSPredicate) -> Observable<T?> {
        fatalError("Should")
    }
    func save(_ object: T) -> Observable<T> {
        fatalError("Should")
    }

    func generateUUID() -> UUID {
        return UUID()
    }
}

public protocol TokenGenerator {
    func generate() -> String
}

