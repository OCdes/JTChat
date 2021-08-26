//
//  EmojiKeyboardView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class EmojiKeyboardView: UIView {
    var viewModel: EmojiViewModel = EmojiViewModel()
    var dataArr: Array<Dictionary<String, Any>> = []
    var collection: UICollectionView?
    private var previosY: CGFloat = 0
    var subject: PublishSubject<String> = PublishSubject<String>()
    var deletSubject: PublishSubject<Any> = PublishSubject<Any>()
    var sendSubject: PublishSubject<Any> = PublishSubject<Any>()
    lazy var deletBtn: UIButton = {
        let db = UIButton()
        db.setImage(JTBundleTool.getBundleImg(with:"deleteKey"), for: .normal)
        db.backgroundColor = HEX_FFF
        db.layer.cornerRadius = 3
        db.layer.masksToBounds = true
        db.addTarget(self, action: #selector(deletBtnClicked(btn:)), for: .touchUpInside)
        return db
    }()
    lazy var sendBtn: UIButton = {
        let sb = UIButton()
        sb.setTitle("发送", for: .normal)
        sb.setTitleColor(HEX_999, for: .normal)
        sb.backgroundColor = HEX_FFF
        sb.layer.cornerRadius = 3
        sb.layer.masksToBounds = true
        sb.addTarget(self, action: #selector(sendBtnClicked(btn:)), for: .touchUpInside)
        return sb
    }()
    lazy var maskV: UIView = {
        let mv = UIView()
        mv.backgroundColor = kIsFlagShip ? UIColor.clear : HEX_COLOR(hexStr: "#F5F5F5")
        mv.alpha = 1
        return mv
    }()
    let width: CGFloat = 26.5
    let keyheight = kScreenWidth-90
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewModel.refreshData()
        let lay = UICollectionViewFlowLayout.init()
        lay.itemSize = CGSize(width: width, height: width)
        lay.minimumLineSpacing = width
        lay.minimumInteritemSpacing = width
        lay.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: width+30, right: 14)
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: lay)
        collection?.backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_COLOR(hexStr: "#F5F5F5")
        collection?.delegate = self
        collection?.dataSource = self
        collection?.register(EmojiItem.self, forCellWithReuseIdentifier: "EmojiItem")
        if #available(iOS 11.0, *) {
            collection?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
//            collection?.automaticallyAdjustsScrollViewInsets = false
        }
        self.addSubview(collection!)
        collection?.snp_makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        
        let msBgv = UIView()
        msBgv.backgroundColor = kIsFlagShip ? UIColor.clear : HEX_COLOR(hexStr: "#F5F5F5")
        self.addSubview(msBgv)
        msBgv.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.size.equalTo(CGSize(width: width*5+16, height: width+45))
        }
        
        self.addSubview(self.maskV)
        maskV.snp_makeConstraints { (make) in
            make.bottom.equalTo(msBgv.snp_top)
            make.left.right.equalTo(msBgv)
            make.height.equalTo(width)
        }
        
        self.addSubview(self.sendBtn)
        self.sendBtn.snp_makeConstraints { (make) in
            make.top.equalTo(msBgv.snp_top)
            make.right.equalTo(self).offset(-14)
            make.size.equalTo(CGSize(width: width*2, height: 40))
        }
        
        self.addSubview(self.deletBtn)
        self.deletBtn.snp_makeConstraints { (make) in
            make.top.equalTo(msBgv.snp_top)
            make.right.equalTo(self.sendBtn.snp_left).offset(-10)
            make.size.equalTo(self.sendBtn)
        }
        
        let _ = viewModel.rx.observe(Array< Dictionary<String, Any>>.self, "dataArr").subscribe(onNext: { [weak self](arr) in
            self!.dataArr = arr ?? []
            self!.collection!.reloadData()
        })
        
        _ = self.collection?.rx.didScroll.subscribe(onNext: { () in
            
        })
    }
    
    @objc func deletBtnClicked(btn: UIButton) {
        self.deletSubject.onNext("")
    }
    
    @objc func sendBtnClicked(btn: UIButton) {
        self.sendSubject.onNext("")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmojiKeyboardView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmojiItem = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiItem", for: indexPath) as! EmojiItem
        cell.dict = dataArr[indexPath.item]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsety = collection!.contentOffset.y
        let off: CGFloat = 5
        let subOffset = offsety-previosY
        if subOffset >= 0 {
            if subOffset < off {
                self.maskV.alpha = 1-subOffset/off
            } else if subOffset >= width+off && subOffset < (width*2) {
                self.maskV.alpha = 1
                previosY = previosY+width*2-off
            } else if subOffset == (width*2) {
                previosY = offsety
                self.maskV.alpha = 1
            }
        } else {
            if abs(subOffset) < off {
                self.maskV.alpha = abs(subOffset)/off
            } else if abs(subOffset) >= width+off && abs(subOffset) < (width*2) {
                self.maskV.alpha = 1
                previosY = previosY-width*2+off
            } else if abs(subOffset) == (width*2) {
                self.maskV.alpha = 1
                previosY = offsety
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = dataArr[indexPath.item]
        subject.onNext(dict["name"] as! String)
    }
    
}

class EmojiItem: BaseCollectionCell {
    var dict: Dictionary<String, Any>? {
        didSet {
            imgv.image = JTBundleTool.getBundleImg(with: dict!["font_class"] as! String)
        }
    }
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

