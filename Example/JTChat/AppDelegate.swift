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
        JTManager.manager.placeID = 2040//2135
        JTManager.manager.isHideBottom = false
        JTManager.manager.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN1c3RvbSI6eyJwbGFjZUNpcGhlciI6ImIyb3g2aXVteUFoYTZQcy9xOGhoRlMxbHEwTXA0Z0FaTVZBM09EWnhJd3RsNUovNHcvd0tZTFVJVTM4V3Z3WkE4S2FqQTVreCtSZDVmNmg3eTN3Ykk3SFpQTExkemhKOHFzaG8razVGOGNYdlNRUE9rUFFYd3hHdjdTaVArMDN1dHJMMmNnT2d3c1d2YlpZVXhQVDhiK3EwN0FTVVdNUEMwc0lCM0ZhdVRId24vL05RVUw3aklWRWNac1NzQ3V1SGlNdGpVZDd0NmNDbmVXWmJsb3AzNTdiM0habzFsQW9uWU9EdFI3NGFUQzNPRWJzYnd2MkpVQ1loS25LOEt0TmRpYzJybWhPM0g4cTA4Ykh2L043UGNQU0VrcStsRmhrTnZtcWFrZGU2a21oUTlWbzN4R1lwdER1SjRBam9JVDFFZ0hrZ01KRWdQeUxMaEpjYUZ3ekZVS2VacTdFbTh2aUVwYXhtM1BHeXo2c2FUbGZld0FHc1I3V05OdHpaN1k5eEk0b2RFMWZmS3Z2VWF0TW1kWUxMMFN2ZFR0UG1MNWdYQXZIckJBdTlxczZNaUt2aG43SnlLUy9HbG9xYmVBRk5VdVh2ZFJobXdudkJtVnJ6dTdJYmpjaEJabG1MT1l2OWNCa0d0bDVWMHRyTmp2cjhLY1FZTUJ4eE9XMVRnRTRBbEExbVVlL1I0eHhCOVF2Mi9oMG5rbXRNemp4SjNQZTFKMGk1NDNMWTBjWWEvTlBhRGtnYjl4UUtvaEJFU2FBZ08vMndQZXk1ekt6bFFrSDlsUkFMSGljL3NkK3pYbU03VC9MMnpoY1RRanF1d25qUVlRVFA3R0ovNVh4VjVxakI0V0s1K3czUVVtcU43aDRHTE0ySGlrQzdrbDZwY2cvcG9qYnlxTmZ2RHI0VFdwL3B1cERIaG5KL1d6ZE1ubTBaYkxhN2w5MTVad3NvbnhlVDBUaVUzWXI3Z205V29zQ3V3eFkxMGttZXk4MCthbTFnbndGU1lIdTJLc0lob2xaK0E2MnNwdDJEcVJtUmd4aUxmSjFiNER5eCtXaFZSbytWRXFkTnZXQmo3dWR0emRneVJ1c0RSWVpiRXkxYlJUcU9JTEZXWHh6NzFEWENWeld2dFlqUCtxOVdBSzlucmY4OVJ5djQvY2wxaDlxOUt4MEw0OVEzb1ZZOFF4b1gzL094UW1IYVZUUjhxNjRIWWhiaDFwRE5nYjRDelJxWmxkVCtudXByQ0ErcTdpVi9nUmp2UEt2Y3psWkNrNDVaS0VGV1dKMVJXNXh3dmp4MFNrRjlRSFNMZ2NGYVIrSGFCSmNna3dYNU5EQW5HRWtDVHk0YUtsT3BZSDhyTEMyTTdaMU1GemZTVUNaRXQ3c3dYL25OaEFtQnVXMEdtUUdlU0RnN1dndXVoTlgwUTZpbUUzUmZPRmdpcGJaZkZaWHlaRWRvcnYwYkxSM015V2JuaytkSFlkMHkwMkpDdWtBZ3RMTHh5YWJqTFBqSHVJOGpJTDBwVEc0SmhIRHVQYnJtNS9FNVphZitTZ2VoVmFDcmY1QmRqR3J3Z1RHNXg1NW02S1l2VTNEKzkzL21BeEFsRVpHRjkramNSdENXWUF0VG8zaXhRUVhGZUkvN296aWVMNGk3NDNxWmd1T2YvcFZwRnIvaDI0cTgyMmhTZGVqWmpmZyt0ZVF0VlJEUDVzUmIvcDhhIiwidXNlck9wZW5JRCI6IiIsInBob25lIjoiMTU5OTk5OTk5OTkiLCJ2ZXJzaW9uTm8iOiIxLjAuOCIsInRlcm1pbmFsVHlwZSI6IkFwcCJ9fQ.eyJzdWIiOiLmjojmnYNBUFDnq6_ku6TniYwiLCJpc3MiOiLnsr7nibnlqLHmsYfmnInpmZDlhazlj7giLCJleHAiOjE2NDY2ODkwNDMsImlhdCI6MTY0NjY0NTg0MywianRpIjoiY2NiOTRiOWFjNGE5NGEzZGI5YzY3NzhlZWFkZGVhNmIifQ.OX5nbd8Xyj8r-AEIXilmLF-6UvbEp4Ujf4gjmtYNF1k"
//        JTManager.manager.ctoken = "dd24c20a94584991a0cf1023032c954e"//51eb8aff2d8149c2bd18d533c0515f94
        JTManager.manager.phone = "15999999999"//15888888888
        JTManager.manager.isFlagShip = false
        JTManager.manager.isSafeQrCode = true
        setRootVC()
        return true
    }
    
    @objc func setRootVC() {
        let tabVC = UITabBarController.init()
        let messageVc = MessageListVC()
        let messageNav = EBaseNavController.init(rootViewController: messageVc)
        messageNav.tabBarItem = UITabBarItem.init(title: "消息", image: UIImage(named: "messageSelected"), tag: 0)

        let conMessageVc = ContactorMessageVC()
        let conMessageNav = EBaseNavController.init(rootViewController: conMessageVc)
        conMessageNav.tabBarItem = UITabBarItem.init(title: "消息", image: UIImage(named: "messageSelected"), tag: 0)
        
        let contactorVc = ConntactersVC()
        let contactorNav = EBaseNavController.init(rootViewController: contactorVc)
        contactorNav.tabBarItem = UITabBarItem.init(title: "联系人", image: UIImage(named: "contacterSelected"), tag: 1)
        tabVC.viewControllers = [ conMessageNav, contactorNav]//messageNav,
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

