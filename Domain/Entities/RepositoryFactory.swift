import Foundation
import RxSwift

public protocol RepositoryFactory {
    static func sync(url:URL, username: String, password: String) -> Observable<Void>
    static var userRepository: AbstractRepository<User> { get }
    static var sessionRepository: AbstractRepository<Session> { get }
}
