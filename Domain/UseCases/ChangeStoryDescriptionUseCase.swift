import Foundation
import RxSwift

public class ChangeStoryDescriptionUseCase: UseCase {
    public struct Input {
        let descriptionTrigger: Observable<String>
        let session: Session
        public init(descriptionTrigger: Observable<String>, session: Session) {
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
        return input.descriptionTrigger.throttle(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest { string -> Observable<Session> in
                var session = input.session
                var currentStory = session.stories.popLast()!
                currentStory.storyDescription = string
                session.stories.append(currentStory)
                return repository.save(session)
            }
    }
}