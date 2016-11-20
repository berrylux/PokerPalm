import Foundation
import RxSwift

public final class SessionElapsedTimeChangedUseCase: UseCase {
    public class func assemble(input: Void, service: Void, output: Void) -> Disposable {
        return Disposables.create()
    }

    public class func assemble(input observableSession: Observable<Session>, service: Void) ->  Observable<TimeInterval> {
        let timer = Observable<NSInteger>.interval(1, scheduler: MainScheduler.instance)
        return timer.withLatestFrom(observableSession).map { session in
            let lastStory = session.stories.last!
            let totalSeconds = Date().timeIntervalSince(lastStory.startTime)
            return totalSeconds
        }
    }

}
