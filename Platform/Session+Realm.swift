import Foundation
import Domain
import RealmSwift


//public struct Session: Identifiable {
//    public let ID = UUID()
//    public let token: String
//    public var name: String
//    public var configuration: Configuration
//    public var stories: [Story]

class RealmSession: Object {
    dynamic var ID: String = ""
    dynamic var token: String = ""
    dynamic var name: String = ""
}
