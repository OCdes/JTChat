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
        JTManager.manager.url = "http://192.168.110.63:14002"//"https://api.hzjtyh.com"
        JTManager.manager.placeID = 2135//2040
        JTManager.manager.isHideBottom = false
        JTManager.manager.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN1c3RvbSI6eyJwbGFjZUNpcGhlciI6ImIyb3g2aXVteUFoYTZQcy9xOGhoRlMxbHEwTXA0Z0FaTVZBM09EWnhJd3RsNUovNHcvd0tZTFVJVTM4V3Z3WkFBL1RReklYdHpOaE54ZzRmZ2s1UzlMSFpQTExkemhKOHFzaG8razVGOGNYdlNRUE9rUFFYd3hHdjdTaVArMDN1dHJMMmNnT2d3c1d2YlpZVXhQVDhiK3EwN0FTVVdNUEMwc0lCM0ZhdVRId24vL05RVUw3aklWRWNac1NzQ3V1SGlNdGpVZDd0NmNDbmVXWmJsb3AzNTdiM0habzFsQW9uWU9EdFI3NGFUQzNPRWJzYnd2MkpVQ1loS25LOEt0TmRpYzJybWhPM0g4cTA4Ykh2L043UGNQU0VrcStsRmhrTnZtcWFrZGU2a21oUTlWbzN4R1lwdER1SjRBam9JVDFFZ0hrZ01KRWdQeUxMaEpjYUZ3ekZVS2VacTdFbTh2aUVwYXhtM1BHeXo2c2FUbGZld0FHc1I3V05OdHpaN1k5eEk0b2RFMWZmS3Z2VWF0TW1kWUxMMFN2ZFR0UG1MNWdYQXZIckJBdTlxczZNaUt2aG43SnlLUy9HbG9xYmVBRk5VdVh2ZFJobXdudkJtVnJ6dTdJYmpjaEJabG1MT1l2OWNCa0d0bDVWMHRyTmp2cjhLY1FZTUJ4eE9XMVRnRTRBR3Z6VDJnNUlHL2NVQ3FJUVJFbWdJQTcxYlg0TUxiSHJuTmpzclQ2aFp4bWJGYjlZZGZRRWV4TWwxMStDY3g4T1R0Y0ZRdjhGTDIzZFZVdzZtbEt2Vko4SlUrV1pEd0U2S2NJMTBWN3dLY2ZIMWkrMks5M2RCemU5Y2dsMGl3ZVBUMkFFMVpnbGNEUGhoWWlneENRdmdNZnhraUQvTnZtUUJ0U3ZRbktNUGIrQUFJeDFCZlFmRE9CRjR3ZlhGT3E3bWZVVnEzSkRTdHk5MXVZV0wxQk5nUTZ3blNObEhEblhTTXk4aHUxZEpRczVEaGdTZEowRzA1Qm8yenFHeFBSdExDTi92QURFT2RQaHNkeWxUeDlFVHdTTm01bm5MTHVYa0R3dnhHdWUyZlhrdkVUWVpucWY0SDNjNzZlNStZSno2QzUrTjRMbWJFUjN6V1NLZDZtZGdXSmZuUmE0RmR5S2VhS1ZUM1lhNmFQaElueW1HdG9WS1YxMGx3dzR3L3h4Qyt0bEtXL1lkdjQ1K3gyS0VUK0tGc2puR2xHUFpGeUJ5bUd2SE9WM1d0YWdIdVNwQlNOYllmdG95ZDNHMG85U1dYVWg5amsxRGxIQ2FCdEVCdHlGRFByV2ViRFlPbGpNS09VWE5vQmdiSEtUL1RzQjZtamZHYUFrQXhUcnZJMEdhaFpyYXAyM0VsUWZmcDZWRjh6YU4wTit0dEFmc0p4RFhnN001eVB2UTRHQXRieWtENWx5TGQyVm5BWjBpVmxQdCs2R2FLWkw3aU9QRnFob3hqbkVYRnNLRDFyL1RrVlBxV3pBTi81SzNaNlg4ZTQ0eWZ0dHhtek5ENkVsc0tGNCIsInVzZXJPcGVuSUQiOiIiLCJwaG9uZSI6IjE1ODg4ODg4ODg4IiwidmVyc2lvbk5vIjoiMS4wLjgiLCJ0ZXJtaW5hbFR5cGUiOiJBcHAifX0.eyJzdWIiOiLmjojmnYNBUFDnq6_ku6TniYwiLCJpc3MiOiLnsr7nibnlqLHmsYfmnInpmZDlhazlj7giLCJleHAiOjE2NDU3MjQ1OTksImlhdCI6MTY0NTY4MTM5OSwianRpIjoiYTg5OWMzYTUzOWEzNGRkMWEyN2RkMzIzYjUzNDVmMTUifQ.x0JxSZtQwBMZ-QZnehzJSiQgj7o81oRM1sRKuMdVY7Y"
//        JTManager.manager.ctoken = "dd24c20a94584991a0cf1023032c954e"//51eb8aff2d8149c2bd18d533c0515f94
        JTManager.manager.phone = "15888888888"//13516776244
        JTManager.manager.isFlagShip = true
        JTManager.manager.isSafeQrCode = true
        setRootVC()
        return true
    }
    
    @objc func setRootVC() {
        let tabVC = UITabBarController.init()
        let messageVc = MessageListVC()
        let messageNav = EBaseNavController.init(rootViewController: messageVc)
        messageNav.tabBarItem = UITabBarItem.init(title: "消息", image: UIImage(named: "messageSelected"), tag: 0)

        let contactorVc = ConntactersVC()
        let contactorNav = EBaseNavController.init(rootViewController: contactorVc)
        contactorNav.tabBarItem = UITabBarItem.init(title: "联系人", image: UIImage(named: "contacterSelected"), tag: 1)
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

