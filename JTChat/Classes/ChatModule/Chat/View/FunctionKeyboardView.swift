//
//  FunctionKeyboardView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import Photos
class FunctionKeyboardView: UIView {
    let keyheight = kScreenWidth-90
    let functionHeight = kScreenWidth-90
    var subject: PublishSubject<String> = PublishSubject<String>()
    lazy var collectionView: FunctionCollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize(width: (kScreenWidth-110)/4, height: (self.functionHeight-45)/2)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: layout.minimumInteritemSpacing, bottom: 15, right: layout.minimumInteritemSpacing)
        let cv = FunctionCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_COLOR(hexStr: "#F5F5F5")
        collectionView.backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_COLOR(hexStr: "#F5F5F5")
        addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(self)
        }
        subject = collectionView.subject
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FunctionCollectionView: BaseCollectionView {
    
    var dataArr: Array<Dictionary<String, Any>> = [["icon":"chat_pictures","name":"照片"],["icon":"chat_takePictur","name":"拍摄"],["icon":"chat_vedio","name":"视频"],["icon":"chat_position","name":"位置"],["icon":"chat_redInvelop","name":"红包"],["icon":"chat_card","name":"名片"]]
    var subject: PublishSubject<String> = PublishSubject<String>()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(FunctionCollectionCell.self, forCellWithReuseIdentifier: "FunctionCollectionCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FunctionCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FunctionCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FunctionCollectionCell", for: indexPath) as! FunctionCollectionCell
        cell.dict = dataArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "", for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = dataArr[indexPath.item]
        let itemName = dict["name"] as! String
        self.subject.onNext(itemName)
    }
    
}

private class FunctionCollectionCell: BaseCollectionCell {
    var dict: Dictionary<String, Any>? {
        didSet {
            imgv.image = JTBundleTool.getBundleImg(with:(dict!["icon"] as! String))
            nameLa.text = (dict!["name"] as! String)
        }
    }
    
     lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        return iv
    }()
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = HEX_666
        nl.textAlignment = .center
        return nl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(imgv.snp_width)
        }
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(imgv.snp_bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

