import XCTest
import RxSwift
import RxTest

@testable import Domain

//

class CreateSessionUseCaseTests: XCTestCase {
    
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
        let startTime = TestScheduler.Defaults.subscribed + 10
        let endTime = TestScheduler.Defaults.subscribed + 20
        let trigger = scheduler.createHotObservable([
                next(startTime, ()),
                completed(endTime)
            ]
        ).asObservable()
        let testUUID = UUID()

        let user = User(ID: testUUID, role: .player,
                        name: "Jon")
        
        let tokenGenerator = StubTokenGenerator()
        let stubSessionRepository = StubSessionRepository()

        stubSessionRepository.uuidClosure = { testUUID }
        var didCheckSessionDoesntExist = false
        stubSessionRepository.queryFirstClosure = { _, _ in
            didCheckSessionDoesntExist = true
            return Observable.just(nil)
        }
        var didSaveSession = false
        stubSessionRepository.saveClosure = { session in
            XCTAssertTrue(session.stories.first!.users.contains(where:{ storyUser in
                return storyUser.ID == user.ID
            }))
            didSaveSession = true
            return Observable.just(session)
        }
        let token = tokenGenerator.generate()
        let expectedSession = Session.dummy(with:testUUID, token, user)

        let testableObserver = scheduler.createObserver(UseCaseState<Session>)

        _ = CreateSessionUseCase.assebmle(
                input: CreateSessionUseCase.Input(user: user, trigger: trigger),
                service: CreateSessionUseCase.Services(sessionIDGenerator: tokenGenerator, repository: stubSessionRepository),
                output: testableObserver.asObserver())

        scheduler.start()
        let inProgressEvent = next(0, UseCaseState<Session>.inProgress)
        let expectedSessionEvent = next(startTime, UseCaseState.succeeded(expectedSession))
        let completedEvent = completed(endTime, UseCaseState<Session>.self)
        let expectedEvents = [inProgressEvent, expectedSessionEvent, completedEvent]
        XCTAssertEqual(testableObserver.events, expectedEvents)
        XCTAssertTrue(didCheckSessionDoesntExist)
        XCTAssertTrue(didSaveSession)
    }
}

class StubTokenGenerator: TokenGenerator {
    func generate() -> String {
        return "some_token"
    }
}


extension Session {
    static func dummy(with uuid: UUID,_ token: String, _ user: User ) -> Session {
        let story = Story(ID: uuid,
                storyDescription: "",
                startTime: Date(),
                endTime: nil,
                users: [user],
                votes: [])
        let sessionConfiguration = Session.Configuration(ID: uuid)
        return Session(ID: uuid, token: token, name: token, configuration: sessionConfiguration, stories: [story])
    }
}

class StubSessionRepository: AbstractRepository<Session> {

    var queryClosure: ((Session.Type, NSPredicate) -> Observable<[Session]>)?
    var queryFirstClosure: ((Session.Type, NSPredicate) -> Observable<Session?>)!
    var saveClosure: ((Session) -> Observable<Session>)!
    var uuidClosure: (() -> UUID)!

    override func query(_ type: Session.Type, with predicate: NSPredicate) -> Observable<[Session]> {
        return queryClosure!(type, predicate)
    }
    override func queryFirst(_ type: Session.Type, with predicate: NSPredicate) -> Observable<Session?> {
        return queryFirstClosure(type, predicate)
    }
    override func save(_ object: Session) -> Observable<Session> {
        return saveClosure(object)
    }

    override func generateUUID() -> UUID {
        return uuidClosure()
    }
}

//class StubSessionRepository: SessionRepository {
//    var queryClosure: ((Session.Type, NSPredicate) -> Observable<[Session]>)?
//    var queryFirstClosure: ((Session.Type, NSPredicate) -> Observable<Session?>)!
//    var saveClosure: ((Session) -> Observable<Session>)!
//    var uuidClosure: (() -> UUID)!
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
//
//    func generateUUID() -> UUID {
//        return uuidClosure()
//    }
//}