//
//  Entities.swift
//  IntentKing
//
//  Created by Bohdan Orlov on 16/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
//public protocol SessionBuilder {
//
//}
public protocol Session {
    var ID: String { get }
    var name: String { get }
    var configuration: SesionConfiguration  { get }
    var stories: [Story] { get }

    static func make(configuration: SesionConfiguration, story: Story) -> Session;
}

public extension Session {
    static var IDk:Attribute<String> { return "ID" }
    static var name:Attribute<String> { return "name" }
    static var configuration:Attribute<String> { return "configuration" }
    static var stories:Attribute<String> { return "stories" }
}

public protocol SesionConfiguration { // TODO: refactor
    var isPlayerAllowedToShow: Bool  { get }
    var isPlayerAllowedToReset: Bool { get }
    var isPlayerAllowedToAmmendSession: Bool { get }
    var isObserverAllowedToShow: Bool { get }
    var isObserverAllowedToReset: Bool { get }
    var isObserverAllowedToAmmendSession: Bool { get }
}

public protocol Story {
    var description: String? { get }
    var startTime: Date { get }
    var endTime: Date? { get }
    var users: [User] { get }
    var votes: [Vote] { get }
}

public protocol Vote {
    var user: User { get }
}

public protocol User {
    var name: String { get }
}

public protocol Player: User {
    var name: String { get }
}

public protocol Observer: User {
    var name: String { get }
}

import RxSwift
public protocol Repository {
    func query<T>(_ type: T.Type, predicate: NSPredicate) -> Observable<[T]>
    func queryFirst<T>(_ type: T.Type, predicate: NSPredicate) -> Observable<T?>
}

public protocol SessionIDGenerator {
    func generate() -> String
}

