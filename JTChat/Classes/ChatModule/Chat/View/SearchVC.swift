//
//  SearchVC.swift
//  JTChat
//
//  Created by jingte on 2021/11/16.
//

import UIKit

class SearchVC: BaseViewController {
    
    private var dataArr: [ContactInfoModel] = []
    
    var viewModel: ContactorViewModel = ContactorViewModel.init()
    lazy var searchTf: UITextField = {
        let stf = UITextField()
        stf.textColor = HEX_333
        stf.textAlignment = .center
        let attach = NSTextAttachment.init()
        attach.image = JTBundleTool.getBundleImg(with: "search")!
        attach.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        let att = NSMutableAttributedString.init(attachment: attach)
        att.append(NSAttributedString.init(string: "请输入手机号搜索添加",attributes: [.foregroundColor : (kIsFlagShip ? HEX_999 : HEX_666)]))
        stf.attributedPlaceholder = att
        stf.returnKeyType = .search
        stf.delegate = self
        stf.backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_COLOR(hexStr: "#e1e1e1")
        stf.layer.cornerRadius = 7.5
        stf.layer.masksToBounds = true
        return stf
    }()
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView.init(frame: CGRect.zero, style: .grouped)
        tv.delegate = self;
        tv.dataSource = self
        tv.register(ContactersTableCell.self, forCellReuseIdentifier: "ContactersTableCell")
        let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
        hv.backgroundColor = kIsFlagShip ? HEX_GOLDBLACK : HEX_FFF
        hv.addSubview(self.searchTf)
        self.searchTf.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        tv.tableHeaderView = hv
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加"
        view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        // Do any additional setup after loading the view.
        
        
    }
    

    

}

extension SearchVC: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let str = textField.text, str.count > 0 {
            textField.resignFirstResponder()
            self.viewModel.getInfoOf(phone: str) { cinfo in
                self.dataArr = [cinfo]
                self.tableView.reloadData()
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactersTableCell", for: indexPath) as! ContactersTableCell
        let mm = self.dataArr[indexPath.row]
        cell.titleLa.text = mm.aliasName.count > 0 ? mm.aliasName : mm.nickName
        cell.portraitV.kf.setImage(with: URL(string: mm.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cinfo = self.dataArr[indexPath.row]
        if cinfo.isFriend {
            SVPShowError(content: "\(cinfo.nickName)已是您的好友")
        } else {
            if JTManager.manager.addFriendSilence {
                self.viewModel.addFriend(friendNickname: cinfo.nickName, friendPhone: cinfo.phone, friendAvatar: cinfo.avatarUrl, remark: "", result: { (b) in
                })
            } else {
                let model = ContactInfoModel()
                model.phone = cinfo.phone
                let alertv = FriendAddAlertView.init(frame: CGRect.zero)
                alertv.model = cinfo
                _ = alertv.sureSubject.subscribe { [weak self](a) in
                    self!.viewModel.addFriend(friendNickname: nil, friendPhone: cinfo.phone, friendAvatar: nil, remark: a, result: { (b) in
                    })
                }
                alertv.show()
            }
        }
    }
}
