import Foundation
import UIKit
import Domain
import Platform
import RxSwift
import RxCocoa

final class SessionViewController: UIViewController {
    @IBOutlet var timerButton: UIBarButtonItem!
    @IBOutlet var inviteButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var card1: UIButton!
    @IBOutlet var card2: UIButton!
    @IBOutlet var card3: UIButton!
    @IBOutlet var card4: UIButton!
    @IBOutlet var card5: UIButton!
    @IBOutlet var clearVotesButton: UIButton!
    @IBOutlet var showVotesButton: UIButton!

    private var session: Session!
    private var currentUser: User!

    class func controller(session: Session, currentUser: User) -> SessionViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        controller.session = session
        controller.currentUser = currentUser
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let observableSession = SessionChangesUseCase.assemble(input: self.session, service: Repositories.sessionRepository)
        observableSession.bindTo(rx.state)
        SessionElapsedTimeChangedUseCase.assemble(input: observableSession, service: Void()).bindTo(rx.timerBinding)

    }
}

fileprivate extension Reactive where Base: SessionViewController {
    var state: UIBindingObserver<Base, Session> {
        return UIBindingObserver(UIElement: base) { controller, session in
            controller.title = session.name
        }
    }
}

fileprivate extension Reactive where Base: SessionViewController {
    var timerBinding: UIBindingObserver<Base, TimeInterval> {
        return UIBindingObserver(UIElement: base) { controller, timeElapsed in
            let seconds = timeElapsed.truncatingRemainder(dividingBy: 60)
            let totalMinutes = (timeElapsed / 60)
            controller.timerButton.title = String(format: "%02.f:%02.f", totalMinutes, seconds)
        }
    }
}
