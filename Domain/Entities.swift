//
//  Entities.swift
//  IntentKing
//
//  Created by Bohdan Orlov on 16/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift

public protocol Identifiable {
    var ID: UUID { get }
}

public struct Session: Identifiable {
    public let ID = UUID()
    public let token: String
    public var name: String
    public var configuration: Configuration
    public var stories: [Story]

    public struct Configuration: Identifiable { // TODO: refactor
        public let ID: UUID
        public var isPlayerAllowedToShow: Bool
        public var isPlayerAllowedToReset: Bool
        public var isPlayerAllowedToAmendSession: Bool
        public var isObserverAllowedToShow: Bool
        public var isObserverAllowedToReset: Bool
        public var isObserverAllowedToAmendSession: Bool

        public init(ID: UUID = UUID(),
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
    static var name:Attribute<String> { return "name" }
    static var configuration:Attribute<String> { return "configuration" }
    static var stories:Attribute<String> { return "stories" }
}

public struct Story: Identifiable {
    public let ID = UUID()
    public var description: String?
    public let startTime: Date
    public var endTime: Date?
    public var users: [User]
    public var votes: [Vote]
}

public struct Vote: Identifiable {
    public let ID = UUID()
    public var user: User
}


public struct User: Identifiable {
    public let ID: UUID
    public let role: Role
    public let name: String
    
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

protocol RepositoryType {
    associatedtype T
    
    func query(_ type: T.Type, with predicate: NSPredicate) -> Observable<[T]>
    func queryFirst(_ type: T.Type, with predicate: NSPredicate) -> Observable<T?>
    func save(_ object: T) -> Observable<T>
}

public protocol UserRepository {
    typealias T = User
    
    func query(_ type: T.Type, predicate: NSPredicate) -> Observable<[T]>
    func queryFirst(_ type: T.Type, predicate: NSPredicate) -> Observable<T?>
    func save(_ object: T) -> Observable<T>
}

public protocol SessionRepository {
    typealias T = Session
    
    func query(_ type: T.Type, predicate: NSPredicate) -> Observable<[T]>
    func queryFirst(_ type: T.Type, predicate: NSPredicate) -> Observable<T?>
    func save(_ object: T) -> Observable<T>
}

public protocol SessionIDGenerator {
    func generate() -> String
}

