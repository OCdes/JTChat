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
        JTManager.manager.url = "http://192.168.0.82:14002"//"https://api.hzjtyh.com"
        JTManager.manager.placeID = 2040
        JTManager.manager.isHideBottom = false
        JTManager.manager.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN1c3RvbSI6eyJwbGFjZUNpcGhlciI6ImIyb3g2aXVteUFoYTZQcy9xOGhoRlMxbHEwTXA0Z0FaTVZBM09EWnhJd3RsNUovNHcvd0tZTFVJVTM4V3Z3WkFBL1RReklYdHpOaE54ZzRmZ2s1UzlMSFpQTExkemhKOHFzaG8razVGOGNYdlNRUE9rUFFYd3hHdjdTaVArMDN1dHJMMmNnT2d3c1d2YlpZVXhQVDhiK3EwN0FTVVdNUEMwc0lCM0ZhdVRId24vL05RVUw3aklWRWNac1NzQ3V1SGlNdGpVZDd0NmNDbmVXWmJsb3AzNTdiM0habzFsQW9uWU9EdFI3NGFUQzNPRWJzYnd2MkpVQ1loS25LOEt0TmRpYzJybWhPM0g4cTA4Ykh2L043UGNQU0VrcStsRmhrTnZtcWFrZGU2a21oUTlWbzN4R1lwdER1SjRBam9JVDFFZ0hrZ01KRWdQeUxMaEpjYUZ3ekZVS2VacTdFbTh2aUVwYXhtM1BHeXo2c2FUbGZld0FHc1I3V05OdHpaN1k5eEk0b2RFMWZmS3Z2VWF0TW1kWUxMMFN2ZFR0UG1MNWdYQXZIckJBdTlxczZNaUt2aG43SnlLUy9HbG9xYmVBRk5VdVh2ZFJobXdudkJtVnJ6dTdJYmpjaEJabG1MT1l2OWNCa0d0bDVWMHRyTmp2cjhLY1FZTUJ4eE9XMVRnRTRBR3Z6VDJnNUlHL2NVQ3FJUVJFbWdJQTcxYlg0TUxiSHJuTmpzclQ2aFp4bWJGYjlZZGZRRWV4TWwxMStDY3g4T1R0Y0ZRdjhGTDIzZFZVdzZtbEt2Vko4SlUrV1pEd0U2S2NJMTBWN3dLY2ZIMWkrMks5M2RCemU5Y2dsMGl3ZVBUMkFFMVpnbGNEUGhoWWlneENRdmdNZnhraUQvTnZtUUJ0U3ZRbktNUGIrQUFJeDFCZlFmRE9CRjR3ZlhGT3E3bWZVVnEzSkRTdHk5MXVZV0wxQk5nZER6VXgxK0xqOUhQNjJQOUJyZmFyWTVEaGdTZEowRzA1Qm8yenFHeFBSdEdFZXVuem9WYnZZNkltKzBESkVZSjIwVDVLRVB2NkFrTWFnekR6NEpVOWxiekpZSnV6Q1V2ZlZiL2cvcHM0d3M3U0oyZ3J4V3BvRE5vbFJjTld4Mmd3SzljKzlvMmJVNFZ1QkVkVk9HWWg3dUJlSWdsUjJkc0w3WmhGWFB3bnZOLzhxZVUrbHJ2YjlqYmY2K1psOGpzQWNUQjI1d3NNeUYyNU9rK05nZFB3d3lpSkY1TWpTV09Dc2piVy9DZXJYQ1YxYy9oUXk1d1lrME53eVlsdktYd2NwcHpIQmNZZDI5V2FESFFHNVkwY2xYcTlGdG1Ba3RCT291NnNDOWFERmJTa2tsRTlrT1RBK3dUNkxaZ1l6ZWFGVm1JeFdPTDROOHhrejdUTjB2TittN05vS1A4Z0dLQUxlWU1IN1pDWlZYWFF3S2ErR0FQVUxUc0Qra1djMDJnVDkvcTRtUkxHRTJMUVh4RHhiYTE0ejRFZElUSkNnM1g4WUMxVTNEMWxlT3FNdUpqekNOZUQ1YWJCK0lqd05CT1hpMG83YWNGQnludkNkMlZ4Z2FTK3d1ZjVyM3FrZWR3bW5CbjhhY1Z5MC9naitMME9ZOVA3cTlVY0hJczAwWXNoZWJNU0srSzVvaS9oZzJaN05ndXN6TGhhWE1qTDVXY015TmtPYXBKOG94IiwidXNlck9wZW5JRCI6IiIsInBob25lIjoiMTU2NjkwMTk1NTciLCJ2ZXJzaW9uTm8iOiIxLjQuNSIsInRlcm1pbmFsVHlwZSI6IkFwcCJ9fQ.eyJzdWIiOiLmjojmnYNBUFDnq6_ku6TniYwiLCJpc3MiOiLnsr7nibnlqLHmsYfmnInpmZDlhazlj7giLCJleHAiOjE2Mzc4NjI0ODcsImlhdCI6MTYzNzgxOTI4NywianRpIjoiNjEzY2NmYjJmZTkzNDQ5ZDhkNzUzYzZiNGM2YjFhNDkifQ.iDMEX7Uon6XiTtxjRXFV3VdnEMHCGCuHpel_nqg3uhk"
//        JTManager.manager.ctoken = "dd24c20a94584991a0cf1023032c954e"//51eb8aff2d8149c2bd18d533c0515f94
        JTManager.manager.phone = "15669019557"//13516776244
        JTManager.manager.isFlagShip = true
        JTManager.manager.isSafeQrCode = true
        setRootVC()
        return true
    }
    
    @objc func setRootVC() {
        let tabVC = UITabBarController.init()
        let messageVc = MessageListVC()
        let messageNav = EBaseNavController.init(rootViewController: messageVc)
        messageNav.tabBarItem = UITabBarItem.init(title: "消息", image: nil, tag: 0)

        let contactorVc = ConntactersVC()
        let contactorNav = EBaseNavController.init(rootViewController: contactorVc)
        contactorNav.tabBarItem = UITabBarItem.init(title: "联系人", image: nil, tag: 1)
        tabVC.viewControllers = [messageNav, contactorNav]
        tabVC.edgesForExtendedLayout = UIRectEdge.all
        tabVC.tabBar.isTranslucent = false
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

