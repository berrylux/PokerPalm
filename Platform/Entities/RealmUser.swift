import Foundation
import Domain
import RealmSwift

final class RealmUser: Object, DomainConvertible {
    dynamic var ID: String = ""
    dynamic var role: Int = 0
    dynamic var name: String = ""
    
    func asDomain() -> User {
        let role = User.Role.init(rawValue: self.role)!

        return User(ID: UUID(uuidString: self.ID)!,
            role: role,
            name: self.name)
    }

    override class func primaryKey() -> String? {
        return User.ID.key
    }
}

extension User: RealmConvertible {
    func asRealm() -> RealmUser {
        let realmUser = RealmUser()
        realmUser.ID = ID.uuidString
        realmUser.role = role.rawValue
        realmUser.name = name

        return realmUser
    }
}


