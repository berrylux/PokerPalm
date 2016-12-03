import Foundation

public struct User: Identifiable {
    public let ID: UUID
    public let role: Role
    public var name: String?
    public func username(for session: Session) -> String {
        let usedNames = session.stories.last!.users.map(session.username)
        return session.username(for: self, skipping: usedNames)
    }


    public init(ID: UUID, role: Role, name: String? = nil) {
        self.ID = ID
        self.role = role
        self.name = name
    }
    
    public enum Role: Int {
        case player
        case observer
    }
}

public extension User {
    static var ID:Attribute<String> { return "ID" }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.ID == rhs.ID &&
            lhs.role == rhs.role &&
            lhs.role == rhs.role
    }
}

extension User: Hashable {
    public var hashValue: Int {
        return self.ID.hashValue ^ self.role.hashValue ^ (self.name?.hashValue ?? 0)
    }

}