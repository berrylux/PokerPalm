import Foundation
import RxSwift

public class ChangeStoryDescriptionUseCase: UseCase {
    public static func assemble(input: Observable<(String, Session)>,
                                service: AbstractRepository<Session>,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return Disposables.create()
    }

    public static func assemble(input: Observable<(String, Session)>,
                                service repository: AbstractRepository<Session>) -> Observable<Session> {
        return input
            .flatMapLatest { string, session -> Observable<Session> in
                var session = session
                var currentStory = session.stories.popLast()!
                currentStory.storyDescription = string
                session.stories.append(currentStory)
                return repository.save(session)
            }
    }
}
