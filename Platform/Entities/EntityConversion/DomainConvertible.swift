import Foundation
import RealmSwift

protocol DomainConvertible {
    associatedtype DomainType
    
    func asDomain() -> DomainType
}
