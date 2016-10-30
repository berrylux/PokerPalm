import Foundation
import Domain
import RealmSwift
import RxSwift
import RxRealm

class RealmRepository<T: RealmConvertible & Identifiable>: AbstractRepository<T> where T == T.RealmType.DomainType {
    init(_ configuration: Realm.Configuration) {
        self.configuration = configuration
        super.init()
    }
    let configuration: Realm.Configuration
    override func query(with predicate: NSPredicate) -> Observable<[T]> {
        let realm = try! Realm(configuration: configuration)
        let objects = realm.objects(T.RealmType.self).filter(predicate)

        return Observable.arrayFrom(objects)
            .map { realmObjects in
                return realmObjects.map {
                    return $0.asDomain()
                }
            }
    }
    
    override func queryFirst(with predicate: NSPredicate) -> Observable<T?> {
        return query(with: predicate)
                .map {
                    $0.first
                }
    }
    
    override func save(_ object: T) -> Observable<T> {
        let realm = try! Realm(configuration: configuration)
        let realmObject = object.asRealm()
        try! realm.write {
            realm.add(realmObject)
        }
        let object = realm.objects(T.RealmType.self).filter("ID == '\(object.ID.uuidString)'")
        return Observable.arrayFrom(object)
            .map {
                return $0.first!.asDomain()
            }
    }
}
