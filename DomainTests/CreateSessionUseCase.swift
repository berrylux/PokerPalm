import XCTest
import RxSwift
import RxTest

@testable import Domain

//

class CreateSessionUseCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Something() {
        let scheduler = TestScheduler(initialClock: 0)
        let trigger = scheduler.createHotObservable([
                next(TestScheduler.Defaults.subscribed + 10, ()),
                completed(TestScheduler.Defaults.subscribed + 20)
            ]
        ).asObservable()
        let user = User(role: .player,
                        name: "Jon")
        
        let tokenGenerator = StubTokenGenerator()        
    }
    
}

class StubTokenGenerator: TokenGenerator {
    func generate() -> String {
        return "some_token"
    }
}


//class StubRepository: Repository {
//    var queryClosure: ((Session.Type, NSPredicate) -> Observable<[Session]>)?
//    var queryFirstClosure: ((Session.Type, NSPredicate) -> Observable<Session?>)!
//    var saveClosure: ((Session) -> Observable<Session>)!
//    
//    func query(_ type: Session.Type, predicate: NSPredicate) -> Observable<[Session]> {
//        return queryClosure!(type, predicate)
//    }
//    func queryFirst(_ type: Session.Type, predicate: NSPredicate) -> Observable<Session?> {
//        return queryFirstClosure(type, predicate)
//    }
//    func save(_ object: Session) -> Observable<Session> {
//        return saveClosure(object)
//    }
//}

