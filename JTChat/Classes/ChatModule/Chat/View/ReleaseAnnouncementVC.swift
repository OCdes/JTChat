//
//  ReleaseAnnouncementVC.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/2/19.
//

import UIKit
import RxSwift
class ReleaseAnnouncementVC: BaseViewController {
    var subject: PublishSubject<String> = PublishSubject<String>()
    var model: GroupInfoModel = GroupInfoModel()
    var noteContent: String = "" {
        didSet {
            self.textV.text = noteContent
        }
    }
    private lazy var textV: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = kIsFlagShip ? HEX_ThemeBlack : HEX_COLOR(hexStr: "#e1e1e1")
        tv.textColor = HEX_333
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.borderColor = HEX_999.cgColor
        tv.layer.borderWidth = 0.5
        tv.layer.cornerRadius = 3
        tv.layer.masksToBounds = true
        return tv
    }()
    
    lazy var submitBtn: UIButton = {
        let sb = UIButton()
        sb.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sb.setTitleColor(UIColor.red, for: .normal)
        sb.addTarget(self, action: #selector(submitClicked), for: .touchUpInside)
        let attstr = NSAttributedString(string: "提    交", attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
        sb.setAttributedTitle(attstr, for: .normal)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布群公告"
        view.addSubview(self.textV)
        self.textV.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(12)
            make.right.equalTo(view).offset(-12)
            make.top.equalTo(view).offset(100)
            make.height.equalTo(kScreenWidth/2)
        }
        
        view.addSubview(self.submitBtn)
        self.submitBtn.snp_makeConstraints { (make) in
            make.top.equalTo(self.textV.snp_bottom).offset(40)
            make.centerX.equalTo(self.textV)
            make.size.equalTo(CGSize(width: 120, height: 50))
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func submitClicked() {
        if self.model.topicGroupID.count > 0 {
            if let str = self.textV.text, str.count > 0, str != self.model.topicGroupDesc {
                self.textV.resignFirstResponder()
                _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_UPDATEGROUPINFO, params: ["topicGroupID":model.topicGroupID,"topicGroupName":"","topicGroupDesc":str,"isTop":""], success: { (msg, code, response, data) in
                    SVPShowSuccess(content: "修改成功")
                    let m = GroupInfoModel()
                    m.topicGroupID = self.model.topicGroupID
                    m.topicGroupName = self.model.topicGroupName
                    m.topicGroupDesc = self.model.topicGroupDesc
                    DBManager.manager.updateGroupInfo(model: m)
                    self.subject.onNext("")
                    self.navigationController?.popViewController(animated: true)
                }, fail: { (errorinfo) in
                    SVPShowError(content: errorinfo.message)
                })
            } else {
                if let str = self.textV.text {
                    if str.count > 0 {
                        SVPShowError(content: "不可以提交重复的公告内容")
                    } else {
                        SVPShowError(content: "公告内容不可以为空")
                    }
                } else {
                    SVPShowError(content: "公告内容不可以为空")
                }
            }
        }
    }
    

}
