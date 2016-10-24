import Foundation

public struct Story: Identifiable {
    public let ID: UUID
    public var storyDescription: String
    public var startTime: Date
    public var endTime: Date?
    public var users: [User]
    public var votes: [Vote]

    public init(ID: UUID,
                storyDescription: String,
                startTime: Date,
                endTime: Date?,
                users: [User],
                votes: [Vote]) {
        self.ID = ID
        self.storyDescription = storyDescription
        self.startTime = startTime
        self.endTime = endTime
        self.users = users
        self.votes = votes
    }
}

extension Story: Equatable {
    public static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.ID == rhs.ID &&
            lhs.storyDescription == rhs.storyDescription &&
            lhs.storyDescription == rhs.storyDescription &&
            lhs.startTime == rhs.startTime &&
            lhs.endTime == rhs.endTime &&
            lhs.users == rhs.users
    }
}
