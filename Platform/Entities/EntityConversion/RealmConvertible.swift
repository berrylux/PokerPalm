import Foundation
import RealmSwift

protocol RealmConvertible {
    associatedtype RealmType: Object, DomainConvertible

    func asRealm() -> RealmType
}
