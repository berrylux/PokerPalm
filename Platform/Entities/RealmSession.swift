import Foundation
import Domain
import RealmSwift

final class RealmSession: Object {
    dynamic var ID: String = ""
    dynamic var token: String = ""
    dynamic var name: String = ""
    dynamic var configuration: RealmSessionConfiguration! = nil
    
    let stories: List<RealmStory> = List()
}

extension RealmSession: DomainConvertible {
    func asDomain() -> Session {
        let stories = self.stories.map { return $0.asDomain() }

        return Session(ID: UUID(uuidString: ID)! ,
                token: token,
                name: name,
                configuration: configuration.asDomain(),
                stories: stories)
    }
}

extension Session: RealmConvertible {
    
    func asRealm() -> RealmSession {
        let object = RealmSession()
        
        object.ID = ID.uuidString
        object.token = token
        object.name = name
        object.configuration = configuration.asRealm()
        object.stories.append(objectsIn: stories.map { $0.asRealm() })
        
        return object
    }
}
