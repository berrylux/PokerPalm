import Foundation
import UIKit
import Domain
import Platform
import RxSwift
import RxCocoa

final class SessionViewController: UIViewController {
    @IBOutlet var timerButton: UIBarButtonItem!
    @IBOutlet var inviteButton: UIBarButtonItem!
    @IBOutlet var storyDescriptionTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var card1: UIButton!
    @IBOutlet var card2: UIButton!
    @IBOutlet var card3: UIButton!
    @IBOutlet var card4: UIButton!
    @IBOutlet var card5: UIButton!
    @IBOutlet var clearVotesButton: UIButton!
    @IBOutlet var showVotesButton: UIButton!

    fileprivate var session: Session!
    private var currentUser: User!
    let disposeBag = DisposeBag()

    class func controller(session: Session, currentUser: User) -> SessionViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SessionViewController") as! SessionViewController
        controller.session = session
        controller.currentUser = currentUser
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let observableSession = SessionChangesUseCase.assemble(input: session, service: Repositories.sessionRepository)
        observableSession
                .bindTo(rx.state)
        
        observableSession.map { session in
            return session.stories.last!.users
        }.bindTo(tableView.rx.items(cellIdentifier: "userCell", cellType: UITableViewCell.self)) { (row, user, cell) in
            cell.textLabel?.text = user.name
        }.addDisposableTo(disposeBag)

        SessionElapsedTimeChangedUseCase.assemble(input: observableSession, service: Void()).bindTo(rx.timerBinding)
        
        let descriptionTrigger = storyDescriptionTextField.rx.text
            .map {
                $0 ?? ""
            }
            .skip(1) //Control produces event on subscribtion which we dont need
        
        let input = Observable.zip(descriptionTrigger,
                                   descriptionTrigger.withLatestFrom(observableSession)) { (string, session) -> (String, Session) in
            return (string, session)
        }.throttle(0.5, scheduler: MainScheduler.instance)
        ChangeStoryDescriptionUseCase.assemble(input: input, service: Repositories.sessionRepository).subscribe()
    }
}

fileprivate extension Reactive where Base: SessionViewController {
    var state: UIBindingObserver<Base, Session> {
        return UIBindingObserver(UIElement: base) { controller, session in
            controller.session = session
            controller.title = session.name
            controller.storyDescriptionTextField.text = session.stories.last!.storyDescription
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


