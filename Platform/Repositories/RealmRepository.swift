import Foundation
import Domain
import RealmSwift
import RxSwift
import RxRealm

class RealmRepository<T: RealmConvertible & Identifiable>: AbstractRepository<T> where T == T.RealmType.DomainType {
    
    func query(with predicate: NSPredicate) -> Observable<[T]> {
        let realm = try! Realm()
        let objects = realm.objects(T.RealmType.self).filter(predicate)

        return Observable.arrayFrom(objects)
            .map { realmObjects in
                return realmObjects.map {
                    return $0.asDomain()
                }
            }
    }
    
    func queryFirst(with predicate: NSPredicate) -> Observable<T?> {
        return query(with: predicate)
                .map {
                    $0.first
                }
    }
    
    func save(_ object: T) -> Observable<T> {
        let realm = try! Realm()
        let realmObject = object.asRealm()
        try! realm.write {
            realm.add(realmObject)
        }
        let object = realm.objects(T.RealmType.self).filter("SELF == \(realmObject)")
        return Observable.arrayFrom(object)
            .map {
                return $0.first!.asDomain()
            }
    }
}
