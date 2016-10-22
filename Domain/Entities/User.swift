import Foundation

public struct User: Identifiable {
    public let ID: UUID
    public let role: Role
    public let name: String

    public init(ID: UUID = UUID(), role: Role, name: String) {
        self.ID = ID
        self.role = role
        self.name = name
    }

    public enum Role: Int {
        case player
        case observer
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.role == rhs.role &&
                lhs.role == rhs.role
    }
}