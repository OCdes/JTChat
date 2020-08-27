//
//  InputToolView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import AudioToolbox
import RxSwift
import YPImagePicker
public protocol InputToolViewDelegate: NSObjectProtocol {
    func keyboardChangeFrame(inY: CGFloat)
}

class InputToolView: UIView {
    private var previousOffsetY: CGFloat = 0
    private var bottomHeight = kScreenWidth-90
    private var bottomOffset: CGFloat = kiPhoneXOrXS ? 34 : 0
    var bottomUpDistance: CGFloat = 0
    var subject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    lazy var emojiView: EmojiKeyboardView = {
        let emk = EmojiKeyboardView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth*2/3))
        return emk
    }()
    lazy var funcView: FunctionKeyboardView = {
        let fv = FunctionKeyboardView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.bottomHeight))
        return fv
    }()
    
    lazy var textV: UITextView = {
        let tv = UITextView()
        tv.textColor = HEX_333
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.delegate = self
        tv.returnKeyType = .send
        return tv
    }()
    
    lazy var voiceBtn: UIButton = {
        let vb = UIButton()
        vb.setTitle("按住  说话", for: .normal)
        vb.setTitle("松开  结束", for: .highlighted)
        vb.isHidden = true
        return vb
    }()
    
    lazy var typeBtn: UIButton = {
        let vb = UIButton()
        vb.setImage(UIImage(named: "voiceicon"), for: .normal)
        vb.setImage(UIImage(named: "texticon"), for: .selected)
        return vb
    }()
    
    lazy var emojBtn: UIButton = {
        let eb = UIButton()
        eb.setImage(UIImage(named: "emojicon"), for: .normal)
        eb.setImage(UIImage(named: "texticon"), for: .selected)
        eb.addTarget(self, action: #selector(emojiBtnClicked(btn:)), for: .touchUpInside)
        return eb
    }()
    
    lazy var moreBtn: UIButton = {
        let mb = UIButton()
        mb.setImage(UIImage(named: "moreicon"), for: .normal)
        mb.addTarget(self, action: #selector(moreBtnClicked(btn:)), for: .touchUpInside)
        return mb
    }()
    var toolV: UIView = UIView()
    var viewModel: ChatViewModel = ChatViewModel()
    weak var delegate: InputToolViewDelegate?
    var keyboardHeight: CGFloat = 0.0
    var textHeight: CGFloat = 0
    var isTyping: Bool = true
    init(frame: CGRect, viewModel vm: ChatViewModel) {
        super.init(frame: CGRect(x: 0, y: kScreenHeight-(62+(kiPhoneXOrXS ? 122 : 64)), width: kScreenWidth, height: (kiPhoneXOrXS ? 96 : 62)))
        viewModel = vm
        backgroundColor = HEX_COLOR(hexStr: "#F5F5F5")
        
        addSubview(toolV)
        toolV.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: self.bottomOffset, right: 0))
        }
        toolV.addSubview(self.typeBtn)
        self.typeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(toolV).offset(7.5)
            make.bottom.equalTo(toolV).offset(-16)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        toolV.addSubview(self.moreBtn)
        self.moreBtn.snp_makeConstraints { (make) in
            make.right.equalTo(toolV).offset(-7.5)
            make.size.centerY.equalTo(self.typeBtn)
        }
        toolV.addSubview(self.emojBtn)
        self.emojBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.moreBtn.snp_left).offset(-10)
            make.size.centerY.equalTo(self.moreBtn)
        }
        
        toolV.addSubview(self.textV)
        self.textV.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeBtn.snp_right).offset(10)
            make.bottom.equalTo(toolV).offset(-16)
            make.right.equalTo(self.emojBtn.snp_left).offset(-10)
            make.top.equalTo(toolV).offset(11)
        }
        
        toolV.addSubview(self.voiceBtn)
        self.voiceBtn.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.voiceBtn)
            make.height.equalTo(40)
        }
        
        let _ = emojiView.subject.subscribe(onNext: { [weak self](string) in
            let str = "[\(string)]"
            var content = self!.textV.text ?? ""
            content.append(str)
            self?.frameChage(newStr: content)
            self?.textV.text = content
//            _ = self?.textView(self!.textV, shouldChangeTextIn: NSRange(location: content.count > 0 ? content.count : 0, length: 0), replacementText: str)
        })
        
        let _ = emojiView.deletSubject.subscribe(onNext: { [weak self](a) in
            if let str = self!.textV.text, str.count > 0 {
                if str.hasSuffix("]") && str.contains("[") {
                    let characters = Array(str)
                    if let start = characters.lastIndex(of: "["), let end = characters.lastIndex(of: "]"), end-start > 1 {
                        let range = NSRange.init(location: start, length: end-start+1)
                        self!.textV.text = (str as NSString).replacingCharacters(in: range, with: "")
                    } else {
                        let range = NSRange.init(location: str.count, length: 1)
                        self!.textV.text = (str as NSString).replacingCharacters(in: range, with: "")
                    }
                } else {
                    let range = NSRange.init(location: str.count, length: 1)
                    self!.textV.text = (str as NSString).replacingCharacters(in: range, with: "")
                }
            }
        })
        
        let _ = emojiView.sendSubject.subscribe(onNext: { [weak self](a) in
            if let str = self!.textV.text, str.count > 0 {
                self!.viewModel.sendMessage(msg: str)
                self!.textHeight = 0
                self?.textV.text = ""
                self?.frameChage(newStr: "")
            }
            
        })
        
        _ = funcView.subject.subscribe(onNext: { [weak self](a) in
            if a == "照片" {
                var config: YPImagePickerConfiguration = YPImagePickerConfiguration.init()
                config.isScrollToChangeModesEnabled = false
                config.onlySquareImagesFromCamera = false
                config.usesFrontCamera = true
                config.hidesBottomBar = true
                config.screens = [.library]
                config.library.maxNumberOfItems = 9
                config.startOnScreen = YPPickerScreen.library
                config.wordings.next = "下一步"
                config.wordings.cancel = "取消"
                config.wordings.libraryTitle = "相册"
                config.wordings.cameraTitle = "相机"
                config.wordings.albumsTitle = "全部相册"
                config.library.defaultMultipleSelection = true
                let picker: YPImagePicker = YPImagePicker.init(configuration: config)
                picker.imagePickerDelegate = self as? YPImagePickerDelegate
                picker.didFinishPicking { [unowned picker] items, _  in
                    if items.count > 0 {
                        self?.viewModel.sendPicture(photos: items)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self?.viewModel.navigationVC?.present(picker, animated: true, completion: nil)
            } else if a == "拍摄" {
                var config: YPImagePickerConfiguration = YPImagePickerConfiguration.init()
                config.isScrollToChangeModesEnabled = false
                config.onlySquareImagesFromCamera = false
                config.usesFrontCamera = true
                config.hidesBottomBar = true
                config.screens = [ .photo]
                config.showsVideoTrimmer = false
                config.showsPhotoFilters = false
                config.shouldSaveNewPicturesToAlbum = false
                config.library.maxNumberOfItems = 9
                config.startOnScreen = YPPickerScreen.library
                config.wordings.next = "下一步"
                config.wordings.cancel = "取消"
                config.wordings.libraryTitle = "相册"
                config.wordings.cameraTitle = "相机"
                config.wordings.albumsTitle = "全部相册"
                config.library.defaultMultipleSelection = true
                let picker: YPImagePicker = YPImagePicker.init(configuration: config)
                picker.imagePickerDelegate = self as? YPImagePickerDelegate
                picker.didFinishPicking { [unowned picker] items, _  in
                    if items.count > 0 {
                        self?.viewModel.sendPicture(photos: items)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self?.viewModel.navigationVC?.present(picker, animated: true, completion: nil)
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(noti: Notification) {
        let dict = noti.userInfo as! Dictionary<String, Any>
        let endFrame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        if self.bottomUpDistance <= endFrame.height {
            self.bottomUpDistance = endFrame.height
            self.keyboardHeight = endFrame.height
            if let de = delegate {
                de.keyboardChangeFrame(inY: endFrame.height+textHeight)
            }
            self.toolV.snp_updateConstraints { (make) in
                make.bottom.equalTo(self).offset(-endFrame.height)
            }
        }
    }
    
    @objc func keyboardWillHide(noti: Notification) {
        let dict = noti.userInfo as! Dictionary<String, Any>
        let endFrame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        if self.bottomUpDistance >= endFrame.height {
            self.bottomUpDistance = endFrame.height
            self.toolV.snp_updateConstraints { (make) in
                make.bottom.equalTo(self).offset(-self.bottomOffset)
            }
            if let de = delegate {
                de.keyboardChangeFrame(inY: textHeight > 19 ? (self.bottomOffset+textHeight) : (kiPhoneXOrXS ? 34 : 0))
            }
            
        }
    }
    
    @objc func emojiBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.textV.resignFirstResponder()
            hideFunctionView()
            self.isTyping = false
            addSubview(emojiView)
            UIView.animate(withDuration: 0.3) {
                self.toolV.snp_updateConstraints { (make) in
                    make.bottom.equalTo(self).offset(-self.bottomHeight)
                }
                
                self.emojiView.snp_makeConstraints { (make) in
                    make.top.equalTo(self.toolV.snp_bottom)
                    make.left.bottom.right.equalTo(self)
                }
                if let de = self.delegate {
                    de.keyboardChangeFrame(inY: self.bottomHeight+self.textHeight)
                }
            }
        } else {
            hideEmojiView()
            self.isTyping = true
            self.textV.becomeFirstResponder()
        }
        
    }
    
    @objc func moreBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.textV.resignFirstResponder()
            hideEmojiView()
            addSubview(funcView)
            UIView.animate(withDuration: 0.3) {
                self.toolV.snp_updateConstraints { (make) in
                    make.bottom.equalTo(self).offset(-self.bottomHeight)
                }
                
                self.funcView.snp_makeConstraints { (make) in
                    make.top.equalTo(self.toolV.snp_bottom)
                    make.left.bottom.right.equalTo(self)
                }
                if let de = self.delegate {
                    de.keyboardChangeFrame(inY: self.bottomHeight+self.textHeight)
                }
            }
        } else {
            hideFunctionView()
            self.isTyping = true
            self.textV.becomeFirstResponder()
        }
    }
    
    func hideEmojiView() {
        self.emojBtn.isSelected = false
        self.toolV.snp_updateConstraints { (make) in
            make.bottom.equalTo(self).offset(-self.bottomOffset)
        }
        self.emojiView.removeFromSuperview()
        if let de = self.delegate {
            de.keyboardChangeFrame(inY: self.bottomOffset+textHeight)
        }
    }
    
    func hideFunctionView() {
        self.moreBtn.isSelected = false
        self.toolV.snp_updateConstraints { (make) in
            make.bottom.equalTo(self).offset(-self.bottomOffset)
        }
        self.funcView.removeFromSuperview()
        if let de = self.delegate {
            de.keyboardChangeFrame(inY: self.bottomOffset+textHeight)
        }
        
    }
    
    func resignActive() {
        //隐藏表情键盘
        if self.emojBtn.isSelected {
            hideEmojiView()
        }
        if self.moreBtn.isSelected {
            hideFunctionView()
        }
        if self.textV.isFirstResponder {
            self.textV.resignFirstResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        print("键盘销毁了")
    }
    
}

extension InputToolView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newStr = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if text == "\n" {
            if let str = textView.text, str.count > 0 {
                viewModel.sendMessage(msg: str)
            }
            newStr = ""
            self.textV.text = newStr
            frameChage(newStr: newStr)
            return false
        }
        frameChage(newStr: newStr)
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        hideEmojiView()
        hideFunctionView()
        self.isTyping = true
        self.emojBtn.isSelected = false
        self.moreBtn.isSelected = false
        return true
    }
    
    func frameChage(newStr: String) {
        let width = kScreenWidth-120
        if newStr.count > 0  {
            let context = NSStringDrawingContext()
            let height = (newStr as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: context).height
            previousOffsetY = height
        } else {
            _ = CGRect(x: 0, y: kScreenHeight-(62+(kiPhoneXOrXS ? 122 : 64)), width: kScreenWidth, height: (kiPhoneXOrXS ? 96 : 62))
            previousOffsetY = 0
        }
        if self.previousOffsetY <= 72 && previousOffsetY > 19.09375 {
            textHeight = previousOffsetY - 19.09375
            if let de = delegate {
                de.keyboardChangeFrame(inY: previousOffsetY - 19.09375 + (self.isTyping ? keyboardHeight : bottomHeight))
            }
        } else if previousOffsetY >= 0 && previousOffsetY < 19.09375 {
            textHeight = previousOffsetY
            if let de = delegate {
                de.keyboardChangeFrame(inY: previousOffsetY + (self.isTyping ? keyboardHeight : bottomHeight))
            }
        }
    }
    
}


