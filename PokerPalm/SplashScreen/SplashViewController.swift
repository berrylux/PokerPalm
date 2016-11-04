import Foundation
import UIKit
import Domain
import Platform
import RxSwift
import RxCocoa

class SplashViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        let trigger = Observable.just()
        let url = URL(string: "http://127.0.0.1:9080")!
        let username = "common@example.com"
        let password = "example"
        let input = RepositorySyncUseCase.Input(trigger: trigger, repositoryURL: url, username: username, password: password)
        let repositorySync = RepositorySyncUseCase.assemble(input: input, service: Repositories.self, output: syncObserver.asObserver()).addDisposableTo(disposeBag)
    }

    var syncObserver: UIBindingObserver<SplashViewController, UseCaseState<Empty>> {
        let val = UIBindingObserver<SplashViewController, UseCaseState<Empty>>(UIElement: self) { controller, state in
            switch state {
            case .inProgress:
                break
            case .succeeded(_):
                break
            case .failed(let error):
                break
            }
        }
        return val
    }




}

