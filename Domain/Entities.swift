
import Foundation
import RxSwift

public protocol Identifiable {
    var ID: UUID { get }
}

public class AbstractRepository<T> {
    func query(_ type: T.Type, with predicate: NSPredicate) -> Observable<[T]> {
        fatalError("Should")
    }
    func queryFirst(_ type: T.Type, with predicate: NSPredicate) -> Observable<T?> {
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

