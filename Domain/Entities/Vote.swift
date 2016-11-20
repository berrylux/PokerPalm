import Foundation

public struct Vote: Identifiable {
    public let ID: UUID
    public var user: User

    public init(ID: UUID, user: User) {
        self.ID = ID
        self.user = user
    }
}


public extension Vote {
    static var ID:Attribute<String> { return "ID" }
}

extension Vote: Equatable {
    public static func == (lhs: Vote, rhs: Vote) -> Bool {
        return lhs.ID == rhs.ID &&
            lhs.user == rhs.user
    }
}
