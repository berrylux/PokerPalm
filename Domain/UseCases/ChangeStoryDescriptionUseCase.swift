import Foundation
import RxSwift

public class ChangeStoryDescriptionUseCase: UseCase {
    public struct Input {
        let descriptionTrigger: Observable<String>
        let session: Observable<Session>
        public init(descriptionTrigger: Observable<String>, session: Observable<Session>) {
            self.descriptionTrigger = descriptionTrigger
            self.session = session
        }
    }

    public static func assemble(input: Input,
                                service: AbstractRepository<Session>,
                                output: AnyObserver<UseCaseState<Session>>) -> Disposable {
        return Disposables.create()
    }

    public static func assemble(input: Input,
                                service repository: AbstractRepository<Session>) -> Observable<Session> {
        let source = input.descriptionTrigger.throttle(0.5, scheduler: MainScheduler.instance)
        return Observable.zip(source, source.withLatestFrom(input.session)) { (string, session) -> (String, Session) in
                    return (string, session)
            }
            .flatMapLatest { string, session -> Observable<Session> in
                var session = session
                var currentStory = session.stories.popLast()!
                currentStory.storyDescription = string
                session.stories.append(currentStory)
                return repository.save(session)
            }
    }
}