import Foundation

public struct User: Identifiable {
    public let ID: UUID
    public let role: Role
    public var name: String

    public init(ID: UUID, role: Role, name: String) {
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
