//
//  BaseNavigationController.swift
//  Swift-jtyh
//
//  Created by 袁炳生 on 2019/12/14.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [
            NSAttributedString.Key.foregroundColor : HEX_FFF,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage.imageWith(color: HEX_ThemeBlack), for: UIBarMetrics.default)
        // Do any additional setup after loading the view.
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        if self.viewControllers.count == 0  {
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}