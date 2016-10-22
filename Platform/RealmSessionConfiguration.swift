import Foundation
import Domain
import RealmSwift


class RealmSessionConfiguration: Object, DomainConvertible {
    dynamic var ID: String = ""
    dynamic var isPlayerAllowedToShow: Bool = false
    dynamic var isPlayerAllowedToReset: Bool = false
    dynamic var isPlayerAllowedToAmendSession: Bool = false
    dynamic var isObserverAllowedToShow: Bool = false
    dynamic var isObserverAllowedToReset: Bool = false
    dynamic var isObserverAllowedToAmendSession: Bool = false

    func asDomain() -> Session.Configuration {
        return Session.Configuration(
                ID: UUID(uuidString: ID)!,
                isPlayerAllowedToShow: isPlayerAllowedToShow,
                isPlayerAllowedToReset: isPlayerAllowedToReset,
                isPlayerAllowedToAmendSession: isPlayerAllowedToAmendSession,
                isObserverAllowedToShow: isObserverAllowedToShow,
                isObserverAllowedToReset: isObserverAllowedToReset,
                isObserverAllowedToAmendSession: isObserverAllowedToAmendSession)
    }
}

extension Session.Configuration: RealmConvertible {
    func asRealm() -> RealmSessionConfiguration {
        let realmObject = RealmSessionConfiguration()
        realmObject.ID = ID.uuidString
        realmObject.isPlayerAllowedToShow = isPlayerAllowedToShow
        realmObject.isPlayerAllowedToReset = isPlayerAllowedToReset
        realmObject.isPlayerAllowedToAmendSession = isPlayerAllowedToAmendSession
        realmObject.isObserverAllowedToShow = isObserverAllowedToShow
        realmObject.isObserverAllowedToReset = isObserverAllowedToReset
        realmObject.isObserverAllowedToAmendSession = isObserverAllowedToAmendSession
        return realmObject
    }
}
