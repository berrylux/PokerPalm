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


    @IBOutlet weak var createSessionButton: UIButton!
    @IBOutlet weak var joinSessionButton: UIButton!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var playerObserverSwitch: UISwitch!

    let disposeBag = DisposeBag()
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        user = User(ID: UUID(),
                role: .player,
                name: "Some Name") // TODO extract to CreateUserUseCase
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let input = CreateSessionUseCase.Input(user: user, trigger: createSessionButton.rx.tap.asObservable())
        let services = CreateSessionUseCase.Services(sessionIDGenerator: DummyTokenGenerator(),
                repository: Repositories.sessionRepository)
        CreateSessionUseCase.assemble(input: input, service: services)
            .takeUntil(rx.sentMessage(#selector(viewWillDisappear))) // TODO check when session changed binding is disposed
            .bindTo(rx.state)
            .addDisposableTo(disposeBag)

        let joinSessionTrigger = joinSessionButton.rx.tap.asObservable().withLatestFrom(tokenTextField.rx.text.map { $0 ?? "" })
        let joinSessionInput = JoinSessionUseCase.Input(sessionTokenTrigger: joinSessionTrigger, user: user)
        JoinSessionUseCase.assemble(input: joinSessionInput, service: Repositories.sessionRepository)
            .takeUntil(rx.sentMessage(#selector(viewWillDisappear))) // TODO check when session changed binding is disposed
            .bindTo(rx.state)
            .addDisposableTo(disposeBag)
    }
}

fileprivate extension Reactive where Base: CreateOrJoinSessionViewController {
    var state: UIBindingObserver<Base, UseCaseState<Session>> {
        return UIBindingObserver(UIElement: base) { controller, state in
            switch state {
                case .succeeded(let session):
                    let sessionController = SessionViewController.controller(session: session, currentUser: controller.user)
                    let navigationController = UINavigationController(rootViewController: sessionController)
                    controller.present(navigationController, animated: true, completion: nil)
            case .failed(let error):
                let alert = UIAlertController(title: "Error",
                                              message: "Failed \(error)",
                    preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss",
                                           style: .cancel,
                                           handler: nil)
                alert.addAction(action)
                controller.present(alert, animated: true)
            default:
                break
            }
        }
    }
}
