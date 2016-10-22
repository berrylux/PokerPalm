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

public enum UseCaseState<T: Equatable>: Equatable{
    case inProgress
    case succeeded(T)
    case failed(Error)

    public static func ==(lhs: UseCaseState, rhs: UseCaseState) -> Bool {
        switch (lhs, rhs) {
            case (.inProgress, .inProgress):
                return true
            case (.succeeded(let lhsValue), .succeeded(let rhsValue)):
                 return lhsValue == rhsValue
            case (.failed(let lhsError), .failed(let rhsError)):
                if (lhsError as AnyObject) === (rhsError as AnyObject) {
                    return true
                }
                if (lhsError as NSError) == (rhsError as NSError) {
                    return true
                }
                return false
            default:
                return false
        }
    }
}

public class CreateSessionUseCase: UseCase {
    public struct Services {
        let sessionIDGenerator: TokenGenerator
        let repository: AbstractRepository<Session>
    }

    public  struct Input {
        let user: User
        let trigger: Observable<Void>
    }

    public static func assebmle(input: Input,
                                service: Services,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return input.trigger
            .flatMapLatest {
                return generateSession(user: input.user, services: service)
            }
            .flatMapLatest(service.repository.save)
            .map(UseCaseState.succeeded)
            .startWith(UseCaseState.inProgress)
            .subscribe(output)
    }

    private static func generateSession(user: User, services: Services)  -> Observable<Session> {
        return Observable.just(services.sessionIDGenerator.generate())
            .flatMapLatest { name -> Observable<(String, Session?)> in
                let predicate: NSPredicate = Session.ID == name
                let justName = Observable.just(name)
                let session = services.repository.queryFirst(Session.self,
                        with: predicate)
                return Observable.zip(justName, session) { (name, session) in
                    return (name, session)
                }
            }
            .flatMapLatest { (name, session) -> Observable<Session> in
                if session == nil {
                    let session = makeSession(with: name, user: user, services: services)
                    return Observable.just(session)
                }
                return generateSession(user: user, services: services)
            }
    }

    private static func makeSession(with token: String, user: User, services: Services) -> Session {
        let story = Story(ID:services.repository.generateUUID(),
                storyDescription: "",
                startTime: Date(),
                endTime: nil,
                users: [user],
                votes: [])
        return Session(ID: services.repository.generateUUID(),
                token: token,
                name: token,
                configuration: Session.Configuration(ID: services.repository.generateUUID()),
                stories: [story])
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
