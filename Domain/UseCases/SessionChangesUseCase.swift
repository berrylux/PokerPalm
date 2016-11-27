import Foundation
import RxSwift

public final class SessionChangesUseCase: UseCase {
    public class func assemble(input: Void, service: Void, output: Void) -> Disposable {
        return Disposables.create()
    }

    public class func assemble(input session: Session, service repository: AbstractRepository<Session>) ->  Observable<Session> {
        return repository.queryFirst(with: Session.ID == session.ID.uuidString).map { $0! }
    }
}
