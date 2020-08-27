//
//  BaseViewController.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/2.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

@objc class BaseViewController: UIViewController , UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var isFullScreen: Bool?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var backBtn: UIButton = {
        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        btn.setImage(UIImage.init(named: "whitNavBack"), for: .normal)
        btn.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var markV: WaterMarkView = {
        var f = self.view.frame
        f.origin.y = 0
        let mv = WaterMarkView.init(frame: f, text: UserInfo.shared.userData?.data.emp_phone ?? "")
//        mv.isHidden = true
        return mv
    }()
    
    lazy var closeBtn: UIButton = {
        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        btn.setImage(UIImage.init(named: "backToHome"), for: .normal)
        btn.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UserInfo.shared.userData?.data.emp_phone) != nil {
            if UserInfo.shared.placeData?.data.placeDetail.isShowWatermark ?? false {
                view.addSubview(self.markV)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.setNav()
        if #available(iOS 11.0, *)  {
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.isExclusiveTouch = true
        
    }
    
    func setNav() {
        self.navigationItem.hidesBackButton = true
        let fixItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixItem.width = -15
        if (self.navigationController?.viewControllers.count ?? 1) > 2 {
            
            self.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: backBtn), fixItem, UIBarButtonItem.init(customView: closeBtn)]
            self.hidesBottomBarWhenPushed = true
        } else if ((self.navigationController?.viewControllers.count ?? 1) > 1) {
            self.navigationItem.leftBarButtonItems = [fixItem, UIBarButtonItem.init(customView: backBtn)]
            self.hidesBottomBarWhenPushed = true
        } else {
            self.hidesBottomBarWhenPushed = false
        }
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 5, vertical: 0),for: UIBarMetrics.default)
    }
    
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            return self.navigationController!.viewControllers.count > 1
        }
        return true
    }
    
    @objc func backClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        let isShowNavi = viewController.isKind(of: SignInVC.self) || viewController.isKind(of: MineVC.self)
//        self.navigationController?.navigationBar.isHidden = isShowNavi
//        self.navigationController?.setNavigationBarHidden(isShowNavi, animated: true)
    }
    
    deinit {
        print("\(object_getClassName(self)) 销毁了")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

