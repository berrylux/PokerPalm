import Foundation
import RxSwift

public class JoinSessionUseCase: UseCase {
    public struct Input {
        let sessionTokenTrigger: Observable<String>
        let user: User
        public init(sessionTokenTrigger: Observable<String>, user: User) {
            self.sessionTokenTrigger = sessionTokenTrigger
            self.user = user
        }
    }

    public static func assemble(input: Input,
                                service: AbstractRepository<Session>,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return Disposables.create()
    }

    public static func assemble(input: JoinSessionUseCase.Input,
                                service repository: AbstractRepository<Session>) -> Observable<UseCaseState<Session>> {
        return input.sessionTokenTrigger
            .flatMapLatest { token -> Observable<Session?> in
                return repository.queryFirst(with: Session.token == token).take(1) // TODO consider making separate query and queryObservable
            }.flatMapLatest { session -> Observable<UseCaseState<Session>> in
                guard var session = session else {
                    return Observable.just(UseCaseState.failed(JoinSessionError()))
                }
                var lastStory = session.stories.popLast()!
                lastStory.users.append(input.user)
                session.stories.append(lastStory)
                return repository.save(session).map(UseCaseState.succeeded)
            }
            .startWith(UseCaseState.inProgress)
            .catchError { error in
                return Observable.just(UseCaseState.failed(error))
            }
    }
}

struct JoinSessionError: Error {
    var localizedDescription: String {
        return "Session with token doesn't exist"
    }
}