//
// Created by Bohdan Orlov on 22/10/2016.
// Copyright (c) 2016 berrylux. All rights reserved.
//

import Foundation
import Domain
import RealmSwift

final class RealmVote: Object, DomainConvertible {
    dynamic var ID = ""
    dynamic var user: RealmUser! = nil

    func asDomain() -> Vote {
        return Vote(ID: UUID(uuidString: ID)!, user: user.asDomain())
    }
}

extension Vote: RealmConvertible {
    func asRealm() -> RealmVote {
        let realmObject = RealmVote()
        realmObject.ID = ID.uuidString
        realmObject.user = user.asRealm()
        return realmObject
    }
}