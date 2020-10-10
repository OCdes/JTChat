//
//  AppDelegate.swift
//  JTChat
//
//  Created by 76515226@qq.com on 08/27/2020.
//  Copyright (c) 2020 76515226@qq.com. All rights reserved.
//

import UIKit
import JTChat
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        JTManager.manager.url = "https://api.hzjtyh.com"
        JTManager.manager.placeID = 2040
//        JTManager.manager.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN1c3RvbSI6eyJ1c2VyT3BlbklEIjoiIiwibWVyY2hhbnRJRCI6MTAzNywicGhvbmUiOiIxNTY2OTAxOTU1NyIsInBsYWNlSUQiOjIwNDAsInZlcnNpb25ObyI6IjEuMC45IiwidGVybWluYWxUeXBlIjoiQXBwIn19.eyJzdWIiOiLmjojmnYNBUFDnq6_ku6TniYwiLCJpc3MiOiLnsr7nibnlqLHmsYfmnInpmZDlhazlj7giLCJleHAiOjE2MDIzMjM1MTEsImlhdCI6MTYwMjIzNzExMSwianRpIjoiYjg5MzIxN2VjNTE5NDM2YThmNzUwNmI1MGNjMTRiMmQifQ.ZEyj0MTIuwmMvF6zrx8mgnJyxC_K9V8CBFptbRepzW8"
        JTManager.manager.ctoken = "7a79f50d35c44a2cbd6d82eb6c253573"
        JTManager.manager.phone = "15838916550"
        setRootVC()
        return true
    }
    
    @objc func setRootVC() {
        let tabVC = UITabBarController.init()
        let messageVc = MessageListVC()
        let messageNav = UINavigationController.init(rootViewController: messageVc)
        messageNav.tabBarItem = UITabBarItem.init(title: "消息", image: nil, tag: 0)

        let contactorVc = ConntactersVC()
        let contactorNav = UINavigationController.init(rootViewController: contactorVc)
        contactorNav.tabBarItem = UITabBarItem.init(title: "联系人", image: nil, tag: 1)
        tabVC.viewControllers = [messageNav, contactorNav]
        tabVC.edgesForExtendedLayout = UIRectEdge.all
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabVC
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

