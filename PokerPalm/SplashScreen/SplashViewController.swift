import Foundation
import UIKit
import Domain
import Platform
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    let subject = PublishSubject<UseCaseState<Empty>>()

    override func viewDidLoad() {
        let trigger = Observable.just()
        let url = URL(string: "http://127.0.0.1:9080")!
        let username = "common@example.com"
        let password = "example"
        let input = RepositorySyncUseCase.Input(
                trigger: trigger,
                repositoryURL: url,
                username: username,
                password: password
        )
        let state = RepositorySyncUseCase.assemble(input: input,
                        service: Repositories.self)
        
        state.bindTo(activityIndicatorView.rx.state)
                .addDisposableTo(disposeBag)
        state.bindTo(stateObserver)
                .addDisposableTo(disposeBag)
    }

    var stateObserver: UIBindingObserver<SplashViewController, UseCaseState<Empty>> {
        let val = UIBindingObserver<SplashViewController, UseCaseState<Empty>>(UIElement: self) { controller, state in
            switch state {
            case .succeeded(_):
                let viewController = controller.storyboard!.instantiateViewController(withIdentifier: "CreateOrJoinSessionViewController")
                controller.present(viewController, animated: true)
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
        return val
    }
}

extension Reactive where Base: UIActivityIndicatorView {
    var state: UIBindingObserver<Base, UseCaseState<Empty>> {
        return UIBindingObserver(UIElement: base) { element, state in
            switch state {
            case .inProgress:
                element.startAnimating()
            case .succeeded(_):
                element.stopAnimating()
            case .failed(let error):
                element.stopAnimating()
            }
        }
    }
}


