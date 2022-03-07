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
        JTManager.manager.jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN1c3RvbSI6eyJwbGFjZUNpcGhlciI6ImIyb3g2aXVteUFoYTZQcy9xOGhoRlMxbHEwTXA0Z0FaTVZBM09EWnhJd3RsNUovNHcvd0tZTFVJVTM4V3Z3WkE4S2FqQTVreCtSZDVmNmg3eTN3Ykk3SFpQTExkemhKOHFzaG8razVGOGNYdlNRUE9rUFFYd3hHdjdTaVArMDN1dHJMMmNnT2d3c1d2YlpZVXhQVDhiK3EwN0FTVVdNUEMwc0lCM0ZhdVRId24vL05RVUw3aklWRWNac1NzQ3V1SGlNdGpVZDd0NmNDbmVXWmJsb3AzNTdiM0habzFsQW9uWU9EdFI3NGFUQzNPRWJzYnd2MkpVQ1loS25LOEt0TmRpYzJybWhPM0g4cTA4Ykh2L043UGNQU0VrcStsRmhrTnZtcWFrZGU2a21oUTlWbzN4R1lwdER1SjRBam9JVDFFZ0hrZ01KRWdQeUxMaEpjYUZ3ekZVS2VacTdFbTh2aUVwYXhtM1BHeXo2c2FUbGZld0FHc1I3V05OdHpaN1k5eEk0b2RFMWZmS3Z2VWF0TW1kWUxMMFN2ZFR0UG1MNWdYQXZIckJBdTlxczZNaUt2aG43SnlLUy9HbG9xYmVBRk5VdVh2ZFJobXdudkJtVnJ6dTdJYmpjaEJabG1MT1l2OWNCa0d0bDVWMHRyTmp2cjhLY1FZTUJ4eE9XMVRnRTRBbEExbVVlL1I0eHhCOVF2Mi9oMG5rbXRNemp4SjNQZTFKMGk1NDNMWTBjWWEvTlBhRGtnYjl4UUtvaEJFU2FBZ08vMndQZXk1ekt6bFFrSDlsUkFMSGljL3NkK3pYbU03VC9MMnpoY1RRanF1d25qUVlRVFA3R0ovNVh4VjVxakI0V0s1K3czUVVtcU43aDRHTE0ySGlrQzdrbDZwY2cvcG9qYnlxTmZ2RHI0VFdwL3B1cERIaG5KL1d6ZE1ubTBaYkxhN2w5MTVad3NvbnhlVDBUaVUzWXI3Z205V29zQ3V3eFkxMGttZXk4MCthbTFnbndGU1lIdTJLc0lob2xaK0E2MnNwdDJEcVJtUmd4aUxmSjFiNER5eCtXaFZSbytWRXFkTnZXQmo3dWR0emRneVJ1c0RSWVpiRXkxYlJUcU9TUlgvU0hZT2M1WFVvQUVTZ3kyVmU2OVdBSzlucmY4OVJ5djQvY2wxaDlvb0c5ZVBVTm53UytWMUUwdDZWT2JQWlh4NFl0Zjk1c1hsaW1VQmJwTDNnRHgwMGFaN0phWVFIZzMvLytmbzE3bndNdzYrSmhpR3pnVXZKR3BQYTh2cmVDNFo2eXFlUWNtNnNROWF1VDNENERZRzVVUFk3SjNTQ052b3NIS0dwOXNDNmRncnZoTEFxTyttL3E1TmxId1lDSm1SdlNsb2hmVWVMSnNLeXdTR1ExdVZHay8ydzB6SUs4YTBwT1NIRVJxUzR1SUtGam5DVmZaWFF6bElEeGFvWkZXMFJWNmNtK3dJWlpsWm5HSDRjNTIzaFVmZ2lVcGhwN3ZNK3c0Y3lIVnIwQUFwUGRob3JRTzZwd2xZRHhld1ExaEZFbDZZNDBrY29CNG1rdHpCVlMzeUQ5bVZHSHVTNDFNSmJRM2JmNjA4bDY1bWdhbnRUTUxIS2grM21ZTGpzeVROazZ2YTRqZGdkVG56cFNrU2RON0NKR3IvNkRNblp4cXM5WXl0akZYOG1HQkEyT0w2WjcxQkIxTjhyU1pRdU9oZjREMzdUWEw4Y1h0dHFXOStHV29YcytpOXBtbHQ5TFpZUGtFWHBvd25MeW1XWVdlNVlNM2lhK1Z0L3ZzY2lzTlgvcWlmZG90TUdGYXJHTjVodlVmc2Z0Z0s4T0I2ZWttRFVNbG9CcVF1VkJYem9ub050dkRLRkdmWDNuQ09YQXFSb25BTnJxeHlUTEQwTUNIdFZRPT0iLCJ1c2VyT3BlbklEIjoiIiwicGhvbmUiOiIxNTY2OTAxOTU1NyIsInZlcnNpb25ObyI6IjEuNS4wIiwidGVybWluYWxUeXBlIjoiQXBwIn19.eyJzdWIiOiLmjojmnYNBUFDnq6_ku6TniYwiLCJpc3MiOiLnsr7nibnlqLHmsYfmnInpmZDlhazlj7giLCJleHAiOjE2NDY2NzI3NDYsImlhdCI6MTY0NjYyOTU0NiwianRpIjoiMGI5OThiNDQ2MmU4NGEwNzliNGYwYWVlODFiN2ZkZTAifQ.omxbsEitgdS8EYG-eBtpLZ3isgz_end3cQ-QePPfjp4"
//        JTManager.manager.ctoken = "dd24c20a94584991a0cf1023032c954e"//51eb8aff2d8149c2bd18d533c0515f94
        JTManager.manager.phone = "15669019557"//15888888888
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

