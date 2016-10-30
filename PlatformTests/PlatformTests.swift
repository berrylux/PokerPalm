//
//  PlatformTests.swift
//  PlatformTests
//
//  Created by Bohdan Orlov on 30/10/2016.
//  Copyright © 2016 berrylux. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RealmSwift
import Nimble
import Domain
@testable import Platform

class RealmRepositoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_WhenObjectIsSaved_ThanReturnedObjectIsEqualToOriginal() {
        //given
        let repository: AbstractRepository<User> = self.repository()
        let user = User(ID: UUID(), role: User.Role.player , name: "User name")
        //when
        var savedUser: User!
        _ = repository.save(user).subscribe(onNext: { user in
            savedUser = user
        })
        //then
        expect(savedUser).toEventually(equal(user))
    }

    func test_WhenObjectIsSaved_ThanItIsInRealm() {
        //given
        let repository: AbstractRepository<User> = self.repository()
        let realm = self.realm()
        let user = User(ID: UUID(), role: User.Role.player , name: "User name")
        //when
        _ = repository.save(user)
        var realmUser: RealmUser?
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500)) {
            realmUser = realm.objects(User.RealmType.self).first!
        }
        //then
        expect(realmUser?.asDomain()).toEventually(equal(user))
    }

    func test_GivenSavedObjectInRealm_WhenChangingRealmObject_ThanChangedObjectIsPushed() {
        //given
        let repository: AbstractRepository<User> = self.repository()
        let realm = self.realm()
        let user = User(ID: UUID(), role: User.Role.player , name: "User name")
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(User.self)
        //when
        _ = repository.save(user).subscribe(observer)
        var realmUser: RealmUser!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500)) {
            realmUser = realm.objects(User.RealmType.self).first!
            try! realm.write {
                realmUser.name = "New name"
                realm.add(realmUser)
            }
        }
        var expectedChangedUser = user
        expectedChangedUser.name = "New name"
        scheduler.start()
        //then
        expect(observer.events.map { event in return event.value.element! }).toEventually(contain(expectedChangedUser))
    }

    func test_GivenSavedObjectInRealm_WhenChangingRealmObject_ThanChangesDeliveredInOrder() {
        //given
        let repository: AbstractRepository<User> = self.repository()
        let realm = self.realm()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(User.self)
        let originalUser = User(ID: UUID(), role: User.Role.player , name: "User name")
        //when
        _ = repository.save(originalUser).subscribe(observer)
        var realmUser: RealmUser!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500)) {
            try! realm.write {
                realmUser = realm.objects(User.RealmType.self).first!
                realmUser.name = "New name"
                realm.add(realmUser)
            }
        }
        var expectedChangedUser = originalUser
        expectedChangedUser.name = "New name"
        scheduler.start()
        //then
        expect(observer.events.map { event in return event.value.element! }).toEventually(equal([originalUser, expectedChangedUser]))
    }

    func configuration(_ identifier: String) -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.inMemoryIdentifier = identifier
        return configuration
    }

    func repository<T: RealmConvertible & Identifiable>(identifier: String = #function) -> AbstractRepository<T> where T == T.RealmType.DomainType {
        return RealmRepository<T>(configuration(identifier))
    }

    func realm(identifier: String = #function) -> Realm {
        return try! Realm(configuration:configuration(identifier))
    }
}
