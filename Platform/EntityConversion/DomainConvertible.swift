import Foundation

protocol DomainConvertible {
    associatedtype DomainType

    func asDomain() -> DomainType

}