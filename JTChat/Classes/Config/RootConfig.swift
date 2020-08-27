//
//  RootConfig.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/1/6.
//  Copyright © 2020 WanCai. All rights reserved.
//

import Foundation

class RootConfig: NSObject {
    @objc public static func reLogin() {
        UserInfo.shared.emptyUserInfo()
        let rootVC = SignInVC.init();
        let nav = BaseNavigationController(rootViewController: rootVC)
        APPWINDOW.rootViewController = nav
    }
    
    public static func setRootController() {
        if UserInfo.shared.userData?.parameter.jwt.count ?? 0 > 0 {
            
        } else {
            let rootVC = SignInVC.init()
            let nav = BaseNavigationController(rootViewController: rootVC)
            APPWINDOW.rootViewController = nav
        }
    }
}



