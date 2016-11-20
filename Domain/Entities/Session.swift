//
// Created by sergdort on 22/10/2016.
// Copyright (c) 2016 berrylux. All rights reserved.
//

import Foundation


public struct Session: Identifiable {
    public let ID: UUID
    public var token: String
    public var name: String
    public var configuration: Configuration
    public var stories: [Story]

    public init(ID: UUID,
                token: String,
                name: String,
                configuration: Configuration,
                stories: [Story]) {
        self.ID = ID
        self.token = token
        self.name = name
        self.configuration = configuration
        self.stories = stories
    }
    
    public struct Configuration: Identifiable { // TODO: refactor
        public let ID: UUID
        public var isPlayerAllowedToShow: Bool
        public var isPlayerAllowedToReset: Bool
        public var isPlayerAllowedToAmendSession: Bool
        public var isObserverAllowedToShow: Bool
        public var isObserverAllowedToReset: Bool
        public var isObserverAllowedToAmendSession: Bool

        public init(ID: UUID,
                    isPlayerAllowedToShow: Bool = true,
                    isPlayerAllowedToReset: Bool = true,
                    isPlayerAllowedToAmendSession: Bool = true,
                    isObserverAllowedToShow: Bool = true,
                    isObserverAllowedToReset: Bool = true,
                    isObserverAllowedToAmendSession: Bool = true) {
            self.ID = ID
            self.isPlayerAllowedToShow = isPlayerAllowedToShow
            self.isPlayerAllowedToReset = isPlayerAllowedToReset
            self.isPlayerAllowedToAmendSession = isPlayerAllowedToAmendSession
            self.isObserverAllowedToShow = isObserverAllowedToShow
            self.isObserverAllowedToReset = isObserverAllowedToReset
            self.isObserverAllowedToAmendSession = isObserverAllowedToAmendSession
        }
    }
}


public extension Session {
    static var ID:Attribute<String> { return "ID" }
    static var token:Attribute<String> { return "token" }
    static var name:Attribute<String> { return "name" }
    static var configuration:Attribute<String> { return "configuration" }
    static var stories:Attribute<String> { return "stories" }
}

public extension Session.Configuration {
    static var ID:Attribute<String> { return "ID" }
}

extension Session: Equatable {
    public static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.ID == rhs.ID &&
            lhs.token == rhs.token &&
            lhs.token == rhs.token &&
            lhs.name == rhs.name &&
            lhs.configuration == rhs.configuration
    }
}

extension Session.Configuration: Equatable {
    public static func == (lhs: Session.Configuration, rhs: Session.Configuration) -> Bool {
        return lhs.ID == rhs.ID &&
            lhs.isPlayerAllowedToShow == rhs.isPlayerAllowedToShow &&
            lhs.isPlayerAllowedToShow == rhs.isPlayerAllowedToShow &&
            lhs.isPlayerAllowedToReset == rhs.isPlayerAllowedToReset &&
            lhs.isPlayerAllowedToAmendSession == rhs.isPlayerAllowedToAmendSession &&
            lhs.isObserverAllowedToShow == rhs.isObserverAllowedToShow &&
            lhs.isObserverAllowedToReset == rhs.isObserverAllowedToReset
    }
}
