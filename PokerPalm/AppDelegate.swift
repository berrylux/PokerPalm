//
//  AppDelegate.swift
//  PokerPalm
//
//  Created by Bohdan Orlov on 16/10/2016.
//  Copyright © 2016 berrylux. All rights reserved.
//

import UIKit
import RxSwift
import Domain
import Platform

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var testObserver: AnyObserver<UseCaseState<Session>> {
        return AnyObserver { event in

        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Repository.sync(URL(string: "http://127.0.0.1:9080")!, "common@example.com", "example").subscribe(onNext: {
            let input = CreateSessionUseCase.Input(user: User(ID: UUID(), role: .player, name: "Bob"), trigger: Observable.just())
            let services = CreateSessionUseCase.Services(sessionIDGenerator: UUIDTokenGenerator(), repository: Repository.session)
            CreateSessionUseCase.assebmle(input: input, service: services, output: self.testObserver)
        }, onError: { error in

        })
//        let trigger = Repository.sync(URL(string: "http://127.0.0.1:9080")!, "common@example.com", "example")


        return true
    }

    class UUIDTokenGenerator: TokenGenerator {
        func generate() -> String {
            return UUID().uuidString
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

