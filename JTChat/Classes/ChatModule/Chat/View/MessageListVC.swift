//
//  MessageListVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import ALQRCode
open class MessageListVC: BaseViewController {
    var viewModel: MessageViewModel = MessageViewModel()
    lazy var scrollView: RecentDialogView = {
        let tv = RecentDialogView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.view.frame.height-45), viewModel: self.viewModel)
        return tv
    }()
    var previousBtn: UIButton?
    var perBtn: UIButton?
    var groupBtn: UIButton?
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        setNav()
        initView()
        bindModel()
        // Do any additional setup after loading the view.
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.viewModel.getMessageList(scrollView: self.scrollView)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func setNav() {
        super.setNav()
        let addBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        addBtn.setImage(JTBundleTool.getBundleImg(with:"addCircle"), for: .normal)
        let _ = addBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (a) in
            let alert = DialogAlertView.init(frame: CGRect.zero)
            _ = alert.subject.subscribe(onNext: { (i) in
                switch i {
                case 0:
                    let vc = GroupChatSelectVC.init()
                    vc.viewModel.navigationVC = self.navigationController
                    self.present(vc, animated: true, completion: nil)
                    
                case 1:
                    let scan = ALScannerQRCodeVC.init()
                    scan.scannerQRCodeDone = {[weak self](result) in
                        self!.viewModel.addFriend()
                    }
                    self.navigationController?.present(scan, animated: true, completion: nil)
                default: break
                    
                }
            })
            alert.show()
        })
        
        let addItem = UIBarButtonItem.init(customView: addBtn)
        navigationItem.setRightBarButton(addItem, animated: true)
    }
    
    func initView() {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth/2, height: 45))
        btn.setImage(JTBundleTool.getBundleImg(with:"createMessage"), for: .normal)
        btn.setTitle("    聊天", for: .normal)
        btn.setTitleColor(HEX_COLOR(hexStr: "#4F525B"), for: .normal)
        btn.setTitleColor(HEX_LightBlue, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(personalBtnClicked(btn:)), for: .touchUpInside)
        self.perBtn = btn
        previousBtn = btn
        view.addSubview(btn)
        let btn2 = UIButton.init(frame: CGRect(x: kScreenWidth/2, y: 0, width: kScreenWidth/2, height: 45))
        btn2.setImage(JTBundleTool.getBundleImg(with:"createGroup"), for: .normal)
        btn2.setTitle("    群聊", for: .normal)
        btn2.setTitleColor(HEX_COLOR(hexStr: "#4F525B"), for: .normal)
        btn2.setTitleColor(HEX_LightBlue, for: .selected)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn2.addTarget(self, action: #selector(groupBtnClicked(btn:)), for: .touchUpInside)
        self.groupBtn = btn2
        view.addSubview(btn2)
        let line = LineView.init(frame: CGRect(x: kScreenWidth/2-1, y: 15, width: 1, height: 15))
        view.addSubview(line)
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: btn.frame.maxY, left: 0, bottom: 0, right: 0))
        }
    }
    
    func bindModel() {
        viewModel.navigationVC = self.navigationController
        _ = viewModel.rx.observe(Int.self, "perNum").subscribe(onNext: { [weak self](num) in
            if let n = num {
                self!.perBtn?.setTitle(n > 0 ? "    聊天(\(n))" : "    聊天", for: .normal)
            }
        })
        _ = viewModel.rx.observe(Int.self, "groupNum").subscribe(onNext: { [weak self](num) in
            if let n = num {
                self!.groupBtn?.setTitle(n > 0 ? "    群聊(\(n))" : "    群聊", for: .normal)
            }
        })
        
    }
    
    @objc func personalBtnClicked(btn: UIButton) {
        previousBtn?.isSelected = false
        if !btn.isSelected {
            btn.isSelected = true
            previousBtn = btn
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    @objc func groupBtnClicked(btn: UIButton) {
        previousBtn?.isSelected = false
        if !btn.isSelected {
            btn.isSelected = true
            previousBtn = btn
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: kScreenWidth, y: 0)
            }
        }
        
    }
    
    deinit {
        print("MessageListVC 销毁了")
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
