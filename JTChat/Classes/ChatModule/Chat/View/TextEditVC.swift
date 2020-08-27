//
//  TextEditVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/7.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class TextEditVC: BaseViewController {
    var subject: PublishSubject<String> = PublishSubject<String>()
    var groupName: String = "" {
        didSet {
            self.textf.text = groupName
        }
    }
    private lazy var textf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入"
        tf.textColor = HEX_333
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.borderColor = HEX_999.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true
        return tf
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(textf)
        textf.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(12)
            make.top.equalTo(view).offset(100)
            make.right.equalTo(view).offset(-12)
            make.height.equalTo(50)
        }
        
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(HEX_FFF, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
//        textf.becomeFirstResponder()
    }
    
    @objc func doneBtnClick() {
        if let str = self.textf.text, str.count > 0, str != self.groupName {
            self.textf.resignFirstResponder()
            self.subject.onNext(str)
        }
        
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
