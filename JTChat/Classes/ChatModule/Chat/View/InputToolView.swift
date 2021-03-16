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
import Photos
public protocol InputToolViewDelegate: NSObjectProtocol {
    func keyboardChangeFrame(inY: CGFloat)
    func keyboardHideFrame(inY: CGFloat)
    func needAtSomeOne(atRange: NSRange)
}

class InputToolView: UIView {
    private var previousOffsetY: CGFloat = 0
    private var bottomHeight = kScreenWidth-90
    private var bottomOffset: CGFloat = 0
    private var atRange: NSRange?
    var bottomUpDistance: CGFloat = 0
    var subject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    var recorder: RecorderManager?
    var levelTimer: Timer?
    var recorCount: Int = 0
    lazy var emojiView: EmojiKeyboardView = {
        let emk = EmojiKeyboardView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth*2/3))
        return emk
    }()
    lazy var funcView: FunctionKeyboardView = {
        let fv = FunctionKeyboardView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.bottomHeight))
        return fv
    }()
    lazy var voiceView: VoiceAlertView = {
        let vv = VoiceAlertView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-(JTManager.manager.isHideBottom ? 116 : 150)))
        return vv
    }()
    lazy var textV: UITextView = {
        let tv = UITextView()
        tv.textColor = HEX_333
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.delegate = self
        tv.returnKeyType = .send
        tv.inputAccessoryView = nil
        tv.reloadInputViews()
//        tv.selectedRange
        return tv
    }()
    
    lazy var voiceBtn: TouchButton = {
        let vb = TouchButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        vb.setTitle("按住  说话", for: .normal)
        vb.setTitle("松开  结束", for: .highlighted)
        vb.isHidden = true
        vb.layer.cornerRadius = 10
        vb.layer.masksToBounds = true
        vb.backgroundColor = HEX_LightBlue
        vb.addTarget(self, action: #selector(voiceBtnTouchupInside(btn:)), for: .touchUpInside)
        vb.addTarget(self, action: #selector(voiceBtnTouchuDown(btn:)), for: .touchDown)
        vb.addTarget(self, action: #selector(voiceBtnTouchUpOutSide(btn:)), for: .touchUpOutside)
        vb.addTarget(self, action: #selector(voiceBtnTouchCancle(btn:)), for: .touchCancel)
        vb.addTarget(self, action: #selector(voiceBtnTouchDragExit(btn:)), for: .touchDragExit)
        vb.addTarget(self, action: #selector(voiceBtnTouchDragEnter(btn:)), for: .touchDragEnter)
        return vb
    }()
    
    lazy var typeBtn: UIButton = {
        let vb = UIButton()
        vb.setImage(JTBundleTool.getBundleImg(with:"voiceicon"), for: .normal)
        vb.setImage(JTBundleTool.getBundleImg(with:"texticon"), for: .selected)
        vb.addTarget(self, action: #selector(typeBtnClicked(btn:)), for: .touchUpInside)
        return vb
    }()
    
    lazy var emojBtn: UIButton = {
        let eb = UIButton()
        eb.setImage(JTBundleTool.getBundleImg(with:"emojicon"), for: .normal)
        eb.setImage(JTBundleTool.getBundleImg(with:"texticon"), for: .selected)
        eb.addTarget(self, action: #selector(emojiBtnClicked(btn:)), for: .touchUpInside)
        return eb
    }()
    
    lazy var moreBtn: UIButton = {
        let mb = UIButton()
        mb.setImage(JTBundleTool.getBundleImg(with:"moreicon"), for: .normal)
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
            make.left.right.top.bottom.equalTo(self.textV)
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
                        self!.frameChage(newStr: self!.textV.text)
                    } else {
                        let range = NSRange.init(location: str.count, length: 1)
                        self!.textV.text = (str as NSString).replacingCharacters(in: range, with: "")
                        self!.frameChage(newStr: self!.textV.text)
                    }
                } else {
                    let range = NSRange.init(location: str.count-1, length: 1)
                    self!.textV.text = (str as NSString).replacingCharacters(in: range, with: "")
                    self!.frameChage(newStr: self!.textV.text)
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
            if a == "照片" || a == "视频" {
                if !checkPhotoLibaray() {
                    return
                }
            } else if a == "拍摄" {
                if !checkCameraAuth() {
                    return
                }
            }
            if a == "照片" {
                var config: YPImagePickerConfiguration = YPImagePickerConfiguration.init()
                config.isScrollToChangeModesEnabled = false
                config.onlySquareImagesFromCamera = false
                config.showsPhotoFilters = false
                config.usesFrontCamera = true
                config.hidesBottomBar = true
                config.screens = [.library]
                config.library.maxNumberOfItems = 9
                config.library.mediaType = .photoAndVideo
                config.video.trimmerMinDuration = 1
                config.video.trimmerMaxDuration = 10
                config.video.fileType = .mp4
                config.startOnScreen = YPPickerScreen.library
                config.albumName = "精特"
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
                config.onlySquareImagesFromCamera = false
                config.screens = [.video, .photo]
                config.startOnScreen = .video
                config.showsPhotoFilters = false
                config.video.fileType = .mp4
                config.library.mediaType = .photoAndVideo
                config.video.recordingTimeLimit = 60
                config.video.minimumTimeLimit = 1
                config.video.trimmerMaxDuration = 10
                config.video.trimmerMinDuration = 1
                config.albumName = "精特"
                config.wordings.next = "下一步"
                config.wordings.cancel = "取消"
                config.wordings.libraryTitle = "相册"
                config.wordings.cameraTitle = "相机"
                config.wordings.albumsTitle = "全部相册"
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
        self.textV.reloadInputViews()
        let dict = noti.userInfo as! Dictionary<String, Any>
        let endFrame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        print(dict)
        if self.bottomUpDistance <= endFrame.height {
            self.bottomUpDistance = endFrame.height
            self.keyboardHeight = endFrame.height-(JTManager.manager.isHideBottom ? 0 : (49+(kiPhoneXOrXS ? 34 : 0)))
            if let de = delegate {
                de.keyboardChangeFrame(inY: self.keyboardHeight+textHeight)
            }
            self.toolV.snp_updateConstraints { (make) in
                make.bottom.equalTo(self).offset(-self.keyboardHeight)
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
                de.keyboardHideFrame(inY: self.bottomOffset+textHeight)
            }
            
        }
    }
    
    @objc func emojiBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.textV.resignFirstResponder()
            hideFunctionView()
            self.isTyping = false
            if self.typeBtn.isSelected {
                self.typeBtnClicked(btn: self.typeBtn)
            }
            addSubview(emojiView)
            UIView.animate(withDuration: 0.3) {
                self.toolV.snp_updateConstraints { (make) in
                    make.bottom.equalTo(self).offset(-self.bottomHeight)
                }
                
                self.emojiView.snp_makeConstraints { (make) in
                    make.top.equalTo(self.toolV.snp_bottom)
                    make.left.right.equalTo(self)
                    make.bottom.equalTo(self).offset(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? -34 : 0) : 0)
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
    
    @objc func typeBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            resignActive()
            self.textV.isHidden = true
            self.voiceBtn.isHidden = false
        } else {
            self.textV.isHidden = false
            self.voiceBtn.isHidden = true
        }
        
    }
    @objc func voiceBtnTouchupInside(btn: UIButton) {
        self.levelTimer?.invalidate()
        self.levelTimer = nil
        //发送
        if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
            print("发送需判断录制时长：touchUpInside")
            self.voiceView.hide()
            if let rec = self.recorder {
                rec.pauseRecorderAudio()
                let pathStr = rec.stopRecorderAudio(byCancle: nil)
                print("录制路径：\(pathStr)")
                if let subPath = (pathStr as NSString).components(separatedBy: "/Caches").last {
                    if AVFManager().durationOf(filePath: subPath) > 0 {
        //                _ = self.recorder?.playAudio(by: pathStr)
                        self.viewModel.sendAudioMessage(path: subPath)
                    } else {
                    }
                }
            }
//            self.recorder = nil
        }
        
    }
    @objc func voiceBtnTouchuDown(btn: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: .audio) == .denied {
            let alertvc = UIAlertController(title: "提示", message: "您的麦克风权限未开启，请开启权限以发送语音", preferredStyle: .alert)
            alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
                let url = URL(string: UIApplication.openSettingsURLString)
                if let u = url, UIApplication.shared.canOpenURL(u) {
                    UIApplication.shared.open(u, options: [:], completionHandler: nil)
                }
            }
            alertvc.addAction(sureAction)
            self.viewModel.navigationVC?.present(alertvc, animated: true, completion: nil)
            return
        } else {
            self.voiceView.showInWindow()
            self.voiceView.imgv.image = JTBundleTool.getBundleImg(with: "voiceLevel_1")
            print("开始录音：TouchDown")
            self.recorder = nil
            let toUser = self.viewModel.contactor!.topicGroupID.count > 0 ? self.viewModel.contactor!.topicGroupID : self.viewModel.contactor!.phone
            let name = "\(JTManager.manager.phone)\(toUser)"
            self.recorder = RecorderManager()
            self.recorder!.beginRecordAudio(name: name)
            self.recorCount = 0
            self.levelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(voiceLevleCallback), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func voiceLevleCallback() {
        if self.recorCount < 30 {
            self.recorCount += 1
        } else {
            self.voiceBtnTouchupInside(btn: UIButton())
        }
        
        if let recorder = self.recorder?.avRecorder {
            recorder.updateMeters()
            var level: Float
            let minDecibels: Float = -80
            let decibels: Float = recorder.averagePower(forChannel: 0)
            if decibels < minDecibels {
                level = 0.0
            } else if decibels >= 0 {
                level = 1
            } else {
                let root: Float = 2
                let minAmp = powf(10.0, 0.05*minDecibels)
                let inverseAmpRange = 1.0/(1.0-minAmp)
                let amp = powf(10.0, 0.05*decibels)
                let adjAmp = (amp-minAmp)*inverseAmpRange
                level = powf(adjAmp, 1.0/root)
            }
            print("level number is \(level)")
            if level > 0 && level < 0.33 {
                self.voiceView.imgv.image = JTBundleTool.getBundleImg(with: "voiceLevel_1")
            } else if level >= 0.33 && level < 0.66 {
                self.voiceView.imgv.image = JTBundleTool.getBundleImg(with: "voiceLevel_2")
            } else if level >= 0.66 && level <= 1.0 {
                self.voiceView.imgv.image = JTBundleTool.getBundleImg(with: "voiceLevel_3")
            } else {
                
            }
        }
        
    }
    
    @objc func voiceBtnTouchUpOutSide(btn: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
            print("取消发送：TouchUpOutSide")
            self.levelTimer?.invalidate()
            self.levelTimer = nil
            self.voiceView.hide()
            if let rec = self.recorder {
                _ = rec.stopRecorderAudio(byCancle: true)
            }
        }
    }
    @objc func voiceBtnTouchCancle(btn: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
            print("取消录制并不发送TouchCancle")
            self.voiceView.hide()
            self.levelTimer?.invalidate()
            self.levelTimer = nil
            if let rec = self.recorder {
                _ = rec.stopRecorderAudio(byCancle: true)
            }
        } else {
            self.recorder = nil
        }
    }
    @objc func voiceBtnTouchDragExit(btn: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
            self.voiceView.imgv.image = JTBundleTool.getBundleImg(with: "cancleSend")
            self.levelTimer?.fireDate = Date.distantFuture
            if let rec = self.recorder {
                rec.pauseRecorderAudio()
            }
            print("暂停录制：TouchDragExit")
        }
    }
    @objc func voiceBtnTouchDragEnter(btn: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
            print("继续录制：TouchDragEnter")
            self.levelTimer?.fireDate = Date.distantPast
            self.voiceView.imgv.image = JTBundleTool.getBundleImg(with: "voiceLevel_1")
            if let rec = self.recorder {
                rec.resume()
            }
        }
    }
    
    @objc func moreBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.textV.resignFirstResponder()
            hideEmojiView()
            if self.typeBtn.isSelected {
                self.typeBtnClicked(btn: self.typeBtn)
            }
            addSubview(funcView)
            UIView.animate(withDuration: 0.3) {
                if let de = self.delegate {
                    de.keyboardChangeFrame(inY: self.bottomHeight+self.textHeight+(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? 34 : 0) : 0))
                }
                
                self.toolV.snp_updateConstraints { (make) in
                    make.bottom.equalTo(self).offset(-self.bottomHeight-(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? 34 : 0) : 0))
                }
                
                self.funcView.snp_makeConstraints { (make) in
                    make.top.equalTo(self.toolV.snp_bottom)
                    make.left.right.equalTo(self)
                    make.bottom.equalTo(self).offset(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? -34 : 0) : 0)
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
            de.keyboardHideFrame(inY: self.bottomOffset+textHeight)
        }
    }
    
    func hideFunctionView() {
        self.moreBtn.isSelected = false
        self.toolV.snp_updateConstraints { (make) in
            make.bottom.equalTo(self).offset(-self.bottomOffset)
        }
        self.funcView.removeFromSuperview()
        if let de = self.delegate {
            de.keyboardHideFrame(inY: self.bottomOffset+textHeight)
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
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let range = self.textV.selectedRange
        for ra in self.viewModel.atRanges {
            if ra.location+ra.length >= range.location && range.location >= ra.location {
                self.textV.selectedRange = NSRange(location: ra.location+ra.length, length: 0)
            }
        }
    }
    
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
        
        if self.viewModel.contactor!.topicGroupID.count > 0 {
            if var ctext = textView.text, newStr.count > 0, text == "" {
                let fromIndex = ctext.index(ctext.startIndex, offsetBy: range.location)
                let endIndex = ctext.index(ctext.startIndex, offsetBy: range.location+range.length)
                let srange = fromIndex..<endIndex
                let replacedStr = String(ctext[srange])
                if replacedStr == " " && ctext.contains("@") {
                    for ra in self.viewModel.atRanges {
                        if ra.location+ra.length-1 == range.location {
                            ctext.removeSubrange(ctext.index(ctext.startIndex, offsetBy: ra.location-1)...ctext.index(ctext.startIndex, offsetBy: ra.location+ra.length-1))
                            self.textV.text = ctext
                            let rindex = self.viewModel.atRanges.lastIndex(of: ra)!
                            self.viewModel.removeAtRange(atIndex: rindex)
                            self.textV.selectedRange = NSRange(location: ra.location-1, length: 0)
                            return false
                        }
                    }
                }
            }
            
            if text == "@" && !isEmailSuffixEqualToAt(textStr: newStr) && (textView.text as NSString).substring(with: range) != "@" {
                if newStr.count > textView.text.count {
                    if let de = self.delegate {
                        self.textV.text = newStr
                        frameChage(newStr: newStr)
                        de.needAtSomeOne(atRange: NSRange(location: range.location+1, length: 0))
                        return false
                    }
                }
                
            }
            
            if range.location < self.textV.text.count {
                self.viewModel.updateRangeBy(addingStr: text, withRange:range)
            }
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
        let width = kScreenWidth-135
        if newStr.count > 0  {
            let context = NSStringDrawingContext()
            let height = (newStr as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: context).height
            previousOffsetY = height
        } else {
            _ = CGRect(x: 0, y: kScreenHeight-(62+(kiPhoneXOrXS ? 122 : 64)), width: kScreenWidth, height: (kiPhoneXOrXS ? 96 : 62))
            previousOffsetY = 0
        }
        print(self.previousOffsetY)
        if self.previousOffsetY <= 72 && previousOffsetY > 19.1 {
            textHeight = previousOffsetY - 19.09375
            if let de = delegate {
                de.keyboardChangeFrame(inY: textHeight + (self.isTyping ? keyboardHeight : bottomHeight))
            }
        } else if previousOffsetY > 0 && previousOffsetY <= 19.1 {
            textHeight = previousOffsetY - 19.09375
            if let de = delegate {
                de.keyboardChangeFrame(inY:(self.isTyping ? keyboardHeight : bottomHeight))
            }
        } else if previousOffsetY == 0  {
            textHeight = 0
            if let de = delegate {
                de.keyboardChangeFrame(inY:(self.isTyping ? keyboardHeight : bottomHeight))
            }
        }
    }
    
}


