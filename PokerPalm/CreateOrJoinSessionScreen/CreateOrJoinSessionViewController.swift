import UIKit
import Domain
import Platform
import RxSwift
import RxCocoa

class DummyTokenGenerator: TokenGenerator {
    func generate() -> String {
        return UUID().uuidString
    }
}

final class CreateOrJoinSessionViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var createSessionButton: UIButton!
    @IBOutlet weak var joinSessionButton: UIButton!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var playerObserverSwitch: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
        let input = CreateSessionUseCase.Input(user: User(ID: UUID(),
                role: .player,
                name: "Some Name"),
                trigger: createSessionButton.rx.tap.asObservable())
        let services = CreateSessionUseCase.Services(sessionIDGenerator: DummyTokenGenerator(),
                repository: Repositories.sessionRepository)

        CreateSessionUseCase.assemble(input: input, service: services)
                .bindTo(rx.state)
                .addDisposableTo(disposeBag)
    }
}

fileprivate extension Reactive where Base: CreateOrJoinSessionViewController {
    var state: UIBindingObserver<Base, UseCaseState<Session>> {
        return UIBindingObserver(UIElement: base) { controller, state in
            print(state)
        }
    }
}
