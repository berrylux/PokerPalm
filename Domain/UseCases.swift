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
        let sessionIDGenerator: TokenGenerator
        let repository: SessionRepository
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
            .flatMapLatest {
                return service.repository.save($0)
            }
            .map(UseCaseState.succeded)
            .startWith(UseCaseState.inProgress)
            .subscribe(output)
    }

    private static func generateSession(user: User, services: Services)  -> Observable<Session> {
        return Observable.just(services.sessionIDGenerator.generate())
            .flatMapLatest(findSession(with: services))
            .flatMapLatest(makeOrGenerateSession(with: services, for: user))
    }

    private  static func findSession(with services: Services)
                    -> (String)
                    -> Observable<(String, Session?)> {
        return { name in
            let justName = Observable.just(name)
            let session = services.repository.queryFirst(Session.self, predicate: Session.ID == name)

            return Observable.zip(justName, session) { (name, session) in
                return (name, session)
            }
        }
    }

    private  static  func makeOrGenerateSession(with services: Services, for user: User)
                    -> ((String, Session?))
                    -> Observable<Session> {
        return { (name, session) in
            if session == nil {
                let session = makeSession(with: name, user: user)
                return Observable.just(session)
            }
            return generateSession(user: user, services: services)
        }
    }

    private static func makeSession(with token: String, user: User) -> Session {
        let story = Story(storyDescription: "",
                          startTime: Date(),
                          endTime: nil,
                          users: [user],
                          votes: [])
        return Session(
                token: token,
                name: token,
                configuration: Session.Configuration(),
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
