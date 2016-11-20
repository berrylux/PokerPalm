import Foundation
import RealmSwift
import Domain

class RealmStory: Object {
    dynamic var ID: String = ""
    dynamic var storyDescription: String = ""
    dynamic var startTime: Date = Date()
    dynamic var endTime: Date? = nil
    
    let users: List<RealmUser> = List()
    let votes: List<RealmVote> = List()

}

extension RealmStory: DomainConvertible {
    typealias RealmType = RealmStory
    
    func asDomain() -> Story {
        let users = self.users.map {
            return $0.asDomain()
        }
        let votes = self.votes.map {
            return $0.asDomain()
        }
        return Story(ID: UUID(uuidString: self.ID)!,
                storyDescription: self.storyDescription,
                startTime: self.startTime,
                endTime: self.endTime,
                users: users,
                votes: votes)
    }

    override class func primaryKey() -> String? {
        return Story.ID.key
    }
}

extension Story: RealmConvertible {

    func asRealm() -> RealmStory {
        let object = RealmStory()

        object.ID = ID.uuidString
        object.storyDescription = storyDescription
        object.startTime = startTime
        object.endTime = endTime
        object.users.append(objectsIn: users.map { $0.asRealm() })
        object.votes.append(objectsIn: votes.map { $0.asRealm() })

        return object
    }
}
