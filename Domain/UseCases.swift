import Foundation
import RxSwift

public protocol UseCase {
    associatedtype I
    associatedtype S
    associatedtype O
    static func assemble(input: I, service: S, output: O) -> Disposable
}

public struct Empty: Equatable {
    public static func == (lhs: Empty, rhs: Empty) -> Bool {
        return true
    }
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
        public init(sessionIDGenerator: TokenGenerator, repository: AbstractRepository<Session>) {
            self.sessionIDGenerator = sessionIDGenerator
            self.repository = repository
        }
    }

    public struct Input {
        let user: User
        let trigger: Observable<Void>
        public init(user:User, trigger:Observable<Void>) {
            self.user = user
            self.trigger = trigger
        }
    }

    public static func assemble(input: Input,
                                service: Services,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return input.trigger
            .flatMapLatest {
                return tryToMakeSession(user: input.user, services: service)
                    .flatMapLatest(service.repository.save)
                    .map(UseCaseState.succeeded)
                    .startWith(UseCaseState.inProgress)
                    .catchError { error in
                        return Observable.just(UseCaseState.failed(error))
                    }
            }
            .subscribe(output)
    }

    private static func tryToMakeSession(user: User, services: Services)  -> Observable<Session> {
        return Observable.just(services.sessionIDGenerator.generate())
            .flatMapLatest(findSession(with: services))
            .flatMapLatest(makeSessionUnlessFound(with: services, for: user))
    }

    private  static func findSession(with services: Services) -> (String) -> Observable<(String, Session?)> {
        return { name in
            let justName = Observable.just(name)
            let session = services.repository.queryFirst(with: Session.ID == name)

            return Observable.zip(justName, session) { (name, session) in
                return (name, session)
            }
        }
    }

    private  static  func makeSessionUnlessFound(with services: Services, for user: User)
                    -> ((String, Session?)) -> Observable<Session> {
        return { (token, session) in
            if session == nil {
                let session = makeSession(with: services, token: token, user: user)
                return Observable.just(session)
            }
            return tryToMakeSession(user: user, services: services)
        }
    }

    private static func makeSession(with services: Services, token: String, user: User) -> Session {
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
