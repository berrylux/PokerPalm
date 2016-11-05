import Foundation
import RxSwift

public final class RepositorySyncUseCase: UseCase {
    public struct Input {
        let trigger: Observable<Void>
        let repositoryURL: URL
        let username: String
        let password: String

        public init(trigger: Observable<Void>, repositoryURL: URL, username: String, password: String) {
            self.trigger = trigger
            self.repositoryURL = repositoryURL
            self.username = username
            self.password = password
        }
    }
    
    public static func assemble(input: RepositorySyncUseCase.Input, service repositoryFactory: RepositoryFactory.Type, output: AnyObserver<UseCaseState<Empty>>) -> Disposable {
        return input.trigger
                .flatMapLatest {
                    return repositoryFactory.sync(url: input.repositoryURL, username: input.username, password: input.password)
                            .map {
                                return UseCaseState<Empty>.succeeded(Empty())
                            }
                            .startWith(UseCaseState.inProgress)
                            .catchError { error in
                                return Observable.just(UseCaseState.failed(error))
                            }
                }
                .subscribe(output)

    }

    public static func assemble(input: RepositorySyncUseCase.Input,
                                service repositoryFactory: RepositoryFactory.Type) -> Observable<UseCaseState<Empty>> {
        return input.trigger
                .flatMapLatest {
                    return repositoryFactory.sync(url: input.repositoryURL, username: input.username, password: input.password)
                            .map {
                                return UseCaseState<Empty>.succeeded(Empty())
                            }
                            .startWith(UseCaseState.inProgress)
                            .catchError { error in
                                return Observable.just(UseCaseState.failed(error))
                            }
                }
                .shareReplay(1)
                .observeOn(MainScheduler.instance)

    }
}
