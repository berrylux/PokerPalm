//
//  GetCurrentUserUseCase.swift
//  PokerPalm
//
//  Created by Bohdan Orlov on 27/11/2016.
//  Copyright © 2016 berrylux. All rights reserved.
//

import Foundation
import RxSwift

public class GetCurrentUserUseCase {

    public static func assemble(input: Observable<Void>,
                                services : (UserDefaults, AbstractRepository<User>)) -> Observable<User> {
        return input
            .flatMapLatest { _ -> Observable<User> in
                let key = "CurrentUserUUID"
                let defaults = services.0
                let repository = services.1
                guard let uuidString = defaults.value(forKey: key) as? String else {
                    let user = User(ID: UUID(), role: User.Role.player)
                    defaults.set(user.ID.uuidString, forKey: key)
                    return repository.save(user)
                }
                return repository.queryFirst(with: User.ID == uuidString)
                    .map { $0! }
        }
    }
}
