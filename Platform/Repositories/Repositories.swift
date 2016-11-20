import Foundation
import RealmSwift
import RxSwift
import Domain

public final class Repositories: RepositoryFactory {


    private static func make<T: RealmConvertible & Identifiable>() -> AbstractRepository<T> where T == T.RealmType.DomainType {
        guard let user = SyncUser.current else {
            fatalError("User must be authenticated before accessing realm")
        }

        // Open Realm
        let url = URL(string:"realm://\(self.url.host!):\(self.url.port!)/shared/poker")!
        let configuration = Realm.Configuration (
                syncConfiguration: SyncConfiguration(user: user, realmURL: url)
        )
        return RealmRepository(configuration)
    }

    public static var userRepository: AbstractRepository<User> {
        return make()
    }

    public static var sessionRepository: AbstractRepository<Session> {
        return make()
    }

    private static var url: URL!
    public static func sync(url:URL, username: String, password: String) -> Observable<Void> {
        return Observable.create { observer in
            SyncManager.shared.logLevel = .debug
            SyncUser.logIn(with: SyncCredentials.usernamePassword(username: username, password: password, register: false), server: url) { user, error in
                if user == nil {
                    if let error = error {
                        observer.onError(error)
                    }
                } else {
                    self.url = url
                    observer.onNext()
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
