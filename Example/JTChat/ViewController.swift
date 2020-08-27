//
//  ViewController.swift
//  JTChat
//
//  Created by 76515226@qq.com on 08/27/2020.
//  Copyright (c) 2020 76515226@qq.com. All rights reserved.
//

import UIKit
import JTChat
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tf = UITextField.init(frame: CGRect(x: 20, y: 150, width: UIScreen.main.bounds.width-40, height: 50))
        tf.placeholder = "请输入手机号"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 1
        tf.backgroundColor = UIColor.white
        view.addSubview(tf)
        
        let ptf = UITextField.init(frame: CGRect(x: 20, y: tf.frame.maxY+20, width: UIScreen.main.bounds.width-40, height: 50))
        ptf.placeholder = "请输入密码"
        ptf.font = UIFont.systemFont(ofSize: 14)
        ptf.layer.borderColor = UIColor.gray.cgColor
        ptf.layer.borderWidth = 1
        ptf.backgroundColor = UIColor.white
        view.addSubview(ptf)
        
        let loginBtn = UIButton.init(frame: CGRect(x: 20, y: ptf.frame.maxY + 80, width: ptf.frame.width, height: 50))
        loginBtn.backgroundColor = UIColor.blue
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginBtn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(loginBtn)
        
        
    }

    @objc func loginBtnClicked() {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

