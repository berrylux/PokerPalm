import Foundation

protocol DomainConvertible {
    associatedtype DomainType

    func asEntity() -> DomainType
    func from(_ entity: DomainType)
}