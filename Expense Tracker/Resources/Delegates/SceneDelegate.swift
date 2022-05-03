//
//  SceneDelegate.swift
//  Expense Tracker
//
//  Created by Shivam Rishi on 25/03/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var themeObserver:NSObjectProtocol?
    
    private let blurEffectView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: sceneWindow)
        self.window = window
        setRootViewController()
        NotificationsManager.shared.requestAuthForLocalNotifications()
        changeTheme()
        themeObserver = NotificationCenter.default.addObserver(forName: .changeTheme,
                                                               object: nil,
                                                               queue: .main,
                                                               using: { [weak self] _ in
            self?.changeTheme()
        })
    }

    private func changeTheme() {
        let darkMode = UserDefaults.standard.bool(forKey: "dark_mode")
        self.window?.overrideUserInterfaceStyle = darkMode ? .dark : .unspecified
    }
        
    private func promptBiometrics(viewController:UIViewController) {
        BiometricsManager().canEvaluatePolicy { [weak self] canEvaluate,_, canEvaluateError in
            guard canEvaluate else {
                UserDefaults.standard.set(false, forKey: "bio_metrics")
                self?.blurEffectView.removeFromSuperview()
                return
            }
            
            BiometricsManager().evaluatePolicy { [weak self] success, error in
                if success {
                    self?.blurEffectView.removeFromSuperview()
                } else {
                    AlertManager.present(
                        title: "App is Locked",
                        message: "For your security, you can only use app when it's unlocked",
                        actions: .unlock(
                            handler: {
                                self?.promptBiometrics(viewController: viewController)
                            }),
                        from: viewController)
                }
            }
        }
    }
    
    private func setRootViewController() {
        let navVC = UINavigationController(rootViewController: HomeViewController())
        navVC.navigationBar.backgroundColor = .clear
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationBar.tintColor = .label
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if let remindDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) {
            NotificationsManager.shared.scheduleLocalNotification(at: remindDate)
        }
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        guard UserDefaults.standard.bool(forKey: "bio_metrics") else {
            return
        }
        if let window = window {
            if let rootViewController = window.rootViewController {
                blurEffectView.frame = rootViewController.view.frame
                rootViewController.view.addSubview(blurEffectView)
                promptBiometrics(viewController: rootViewController)
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        PersistentStorage.shared.saveContext()
        guard UserDefaults.standard.bool(forKey: "bio_metrics") else {
            return
        }
    }


}

