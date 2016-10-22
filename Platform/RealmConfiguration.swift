import Foundation
import Domain
import RealmSwift


class RealmConfiguration: Object, DomainConvertible {
    dynamic var ID: String = ""
    dynamic var isPlayerAllowedToShow: Bool = false
    dynamic var isPlayerAllowedToReset: Bool = false
    dynamic var isPlayerAllowedToAmendSession: Bool = false
    dynamic var isObserverAllowedToShow: Bool = false
    dynamic var isObserverAllowedToReset: Bool = false
    dynamic var isObserverAllowedToAmendSession: Bool = false

    func asEntity() -> Session.Configuration {
        return Session.Configuration(
                ID: UUID(uuidString: ID)!,
                isPlayerAllowedToShow: isPlayerAllowedToShow,
                isPlayerAllowedToReset: isPlayerAllowedToReset,
                isPlayerAllowedToAmendSession: isPlayerAllowedToAmendSession,
                isObserverAllowedToShow: isObserverAllowedToShow,
                isObserverAllowedToReset: isObserverAllowedToReset,
                isObserverAllowedToAmendSession: isObserverAllowedToAmendSession)
    }

    func from(_ entity: Session.Configuration) {
        let realmObject = RealmConfiguration()
        realmObject.ID = entity.ID.uuidString
        realmObject.isPlayerAllowedToShow = entity.isPlayerAllowedToShow
        realmObject.isPlayerAllowedToReset = entity.isPlayerAllowedToReset
        realmObject.isPlayerAllowedToAmendSession = entity.isPlayerAllowedToAmendSession
        realmObject.isObserverAllowedToShow = entity.isObserverAllowedToShow
        realmObject.isObserverAllowedToReset = entity.isObserverAllowedToReset
        realmObject.isObserverAllowedToAmendSession = entity.isObserverAllowedToAmendSession
    }
}
