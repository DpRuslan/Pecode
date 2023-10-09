//
//  AppDelegate.swift
//  

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var coreDataStack = CoreDataStack(modelName: "WorldNews")
    var window: UIWindow?
    var navVC: UINavigationController?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        navVC = UINavigationController()
        coordinator = MainCoordinator()
        
        window?.rootViewController = navVC
        coordinator?.navigationController = navVC
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .systemGray4
        navVC?.navigationBar.standardAppearance = appearence
        navVC?.navigationBar.scrollEdgeAppearance = appearence
        navVC?.navigationBar.compactAppearance = appearence
        
        coordinator?.start()
        
        return true
    }
}
