import Foundation
import RealmSwift
import RxSwift
import Domain

public final class Repository {


    private static func make<T: RealmConvertible & Identifiable>() -> AbstractRepository<T> where T == T.RealmType.DomainType {
        SyncManager.shared().logLevel = .debug
        guard let user = SyncUser.all().first else {
            fatalError("User must be authenticated before accessing realm")
        }

        // Open Realm
        let url = URL(string:"realm://\(self.url.host!):\(self.url.port!)/shared/poker")!
        let configuration = Realm.Configuration(
                syncConfiguration: (user, url)
        )
        return RealmRepository(configuration)
    }

    public static var user: AbstractRepository<User> {
        return make()
    }

    public static var session: AbstractRepository<Session> {
        return make()
    }

    private static var url: URL!
    public static func sync(_ url:URL, _ username: String, _ password: String) -> Observable<Void> {
        return Observable.create { observer in
            SyncUser.authenticate(with: Credential.usernamePassword(username: username, password: password, actions: []), server: url, onCompletion: { user, error in
                if user == nil {
                    if let error = error {
                        observer.onError(error)
                    }
                } else {
                    self.url = url
                    observer.onNext()
                }
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
