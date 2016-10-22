import Foundation

protocol RealmConvertible {
    associatedtype RealmType

    func asRealm() -> RealmType
}