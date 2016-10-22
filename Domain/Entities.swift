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

