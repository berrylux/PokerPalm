import Foundation
import RxSwift

public class JoinSessionUseCase: UseCase {

    public static func assemble(input: Observable<(User, String)>,
                                service: AbstractRepository<Session>,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return Disposables.create()
    }

    public static func assemble(input: Observable<(User, String)>,
                                service repository: AbstractRepository<Session>) -> Observable<UseCaseState<Session>> {
        return input
            .flatMapLatest { (user, token) -> Observable<(User, Session?)> in
                return repository.queryFirst(with: Session.token == token)
                        .take(1)
                        .map { session -> (User, Session?) in (user, session) } // TODO consider making separate query and queryObservable
            }.flatMapLatest { (user, session) -> Observable<UseCaseState<Session>> in
                guard var session = session else {
                    return Observable.just(UseCaseState.failed(JoinSessionError()))
                }
                if session.stories.last!.users.contains(user) {
                    return Observable.just(UseCaseState.succeeded(session))
                }
                var lastStory = session.stories.popLast()!
                lastStory.users.append(user)
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