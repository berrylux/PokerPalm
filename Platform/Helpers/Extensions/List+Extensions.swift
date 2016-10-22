import Foundation
import RealmSwift

extension List {
    func map<U>(_ f: (T) throws -> U) rethrows -> [U]  {
        var mapped = [U]()
        for item in self {
            mapped.append(try f(item))
        }
        return mapped
    }
}
