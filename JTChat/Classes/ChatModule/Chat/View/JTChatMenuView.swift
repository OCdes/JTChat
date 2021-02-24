//
//  JTChatMenuView.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/2/19.
//

import UIKit

protocol JTChatMenuViewDelegate: NSObjectProtocol {
    func retweetMessage(fromMessageView: JTChatMenuView)
    func deleteMessage(fromMessageView: JTChatMenuView)
}

class JTChatMenuView: UIView {
    open weak var delegate: JTChatMenuViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let long = UILongPressGestureRecognizer.init(target: self, action: #selector(long(long:)))
        long.minimumPressDuration = 1.5
        self.addGestureRecognizer(long)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if [#selector(copyItem), #selector(retweetItem),#selector(deletItem)].contains(action) {
                    return true
                }
                return false
    }
    
    @objc func long(long:UILongPressGestureRecognizer) {
        if UIMenuController.shared.isMenuVisible {
            return
        }
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        let cItem = UIMenuItem.init(title: "复制", action: #selector(copyItem))
        let reItem = UIMenuItem.init(title: "转发", action: #selector(retweetItem))
        let deItem = UIMenuItem.init(title: "删除", action: #selector(deletItem))
        var items = [reItem,deItem]
        for v in self.subviews {
            if v.isKind(of: UILabel.self) {
                items.insert(cItem, at: 0)
            }
        }
        menu.menuItems = items
        menu.setTargetRect(self.bounds, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    
    @objc func copyItem() {
        for v in self.subviews {
            if v.isKind(of: UILabel.self) {
                let la = v as! UILabel
                UIPasteboard.general.string = la.text
            }
        }
    }
    
    @objc func retweetItem() {
        if let de = self.delegate {
            de.retweetMessage(fromMessageView: self)
        }
    }
    
    @objc func deletItem() {
        if let de = self.delegate {
            de.deleteMessage(fromMessageView: self)
        }
    }
}




