//
//  Entities.swift
//  IntentKing
//
//  Created by Bohdan Orlov on 16/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
//public struct SessionBuilder {
//
//}
protocol Identifiable {
    var ID: UUID { get }
}

public struct Session: Identifiable {
    let ID = UUID()
    let token: String
    var name: String
    var configuration: SesionConfiguration
    var stories: [Story]

    public struct SesionConfiguration: Identifiable { // TODO: refactor
        let ID: UUID
        var isPlayerAllowedToShow: Bool
        var isPlayerAllowedToReset: Bool
        var isPlayerAllowedToAmmendSession: Bool
        var isObserverAllowedToShow: Bool
        var isObserverAllowedToReset: Bool
        var isObserverAllowedToAmmendSession: Bool

        init(isPlayerAllowedToShow: Bool = true,
             isPlayerAllowedToReset: Bool = true,
             isPlayerAllowedToAmmendSession: Bool = true,
             isObserverAllowedToShow: Bool = true,
             isObserverAllowedToReset: Bool = true,
             isObserverAllowedToAmmendSession: Bool = true) {
            ID = UUID()
            self.isPlayerAllowedToShow = isPlayerAllowedToShow
            self.isPlayerAllowedToReset = isPlayerAllowedToReset
            self.isPlayerAllowedToAmmendSession = isPlayerAllowedToAmmendSession
            self.isObserverAllowedToShow = isObserverAllowedToShow
            self.isObserverAllowedToReset = isObserverAllowedToReset
            self.isObserverAllowedToAmmendSession = isObserverAllowedToAmmendSession
        }
    }
}

public extension Session {
    static var IDk:Attribute<String> { return "ID" }
    static var name:Attribute<String> { return "name" }
    static var configuration:Attribute<String> { return "configuration" }
    static var stories:Attribute<String> { return "stories" }
}

public struct Story: Identifiable {
    let ID = UUID()
    var description: String?
    let startTime: Date
    var endTime: Date?
    var users: [User]
    var votes: [Vote]
}

public struct Vote: Identifiable {
    let ID = UUID()
    var user: User
}


public struct User: Identifiable {
    let ID = UUID()
    let role: Role
    let name: String

    public enum Role {
        case player
        case observer
    }
}

import RxSwift
public protocol Repository {
    func query<T>(_ type: T.Type, predicate: NSPredicate) -> Observable<[T]>
    func queryFirst<T>(_ type: T.Type, predicate: NSPredicate) -> Observable<T?>
    func save<T>(_ object: T)
}

public protocol SessionIDGenerator {
    func generate() -> String
}

