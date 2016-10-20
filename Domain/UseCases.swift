//
//  UseCases.swift
//  IntentKing
//
//  Created by Bohdan Orlov on 16/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift

public protocol UseCase {
    associatedtype I
    associatedtype S
    associatedtype O
    static func assebmle(input: I, service: S, output: O) -> Disposable
}

public enum UseCaseState<T> {
    case inProgress
    case succeded(T)
    case failed(Error)
}

public class CreateSessionUseCase: UseCase {
    public struct Services {
        let sessionIDGenerator: SessionIDGenerator
        let storage: Repository
    }

    public static func assebmle(input: Observable<Void>,
                                service: Services,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return input.flatMap {
                return generateSession(services: service)
            }
            .map {
                return UseCaseState.succeded($0)
            }
            .startWith(UseCaseState.inProgress)
            .subscribe(output)
    }
    private static func generateSession(services: Services) -> Observable<Session> {
        return Observable.just(services.sessionIDGenerator.generate())
            .flatMapLatest { name -> Observable<Session?> in
                let predicate: NSPredicate = Attribute<String>("name") == name
                return services.storage.queryFirst(Session.self,
                                                  predicate: predicate)
            }
            .flatMapLatest { session -> Observable<Session> in
                guard let session = session else {
                    return Observable.empty() // TODO. Create Session
                }
                return generateSession(services: services)
            }
    }
}



class JoinSessionUseCase {

}

class ChangeStoryDescriptionUseCase {

}

class VoteUseCase {

}

class ShowVotesUseCase {

}

class ResetVotesUseCase {

}

class NextStoryUseCase {

}

class ShowHistoryUseCase {
    
}
