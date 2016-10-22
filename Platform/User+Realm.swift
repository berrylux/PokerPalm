import Foundation
import Domain
import RealmSwift

class RealmUser: Object {
    dynamic var ID: String = ""
    dynamic var role: Int = 0
    dynamic var name: String = ""
    
    func asUser() -> User {
        let role = User.Role.init(rawValue: self.role) ?? User.Role.player
        return User(ID: UUID(uuidString: self.ID) ?? UUID(),
            role: role,
            name: self.name)
    }
    
    func from(_ user: User) -> RealmUser {
        let realmUser = RealmUser()
        realmUser.ID = user.ID.uuidString
        realmUser.role = user.role.rawValue
        realmUser.name = user.name
        
        return realmUser
    }
}


