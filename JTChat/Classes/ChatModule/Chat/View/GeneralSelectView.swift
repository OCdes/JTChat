//
//  GeneralSelectView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/4.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class GeneralSelectView: UIView {
    var dataArr: Array<GeneralSelectModel>? {
        didSet {
            sureBtn.setTitle("确定(\(dataArr!.count))", for: .normal)
            self.collectionView.reloadData()
        }
    }
    
    var selectIDArr: Array<String>? {
        set{}
        get {
            var arr: Array<String> = []
            for m in dataArr ?? [] {
                arr.append(m.phone)
            }
            return arr
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = HEX_COLOR(hexStr: "#e1e1e1")
        cv.register(GeneralSelectItem.self, forCellWithReuseIdentifier: "GeneralSelectItem")
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(HEX_LightBlue, for: .normal)
        btn.addTarget(self, action: #selector(sureBtnClicked(btn:)), for: .touchUpInside)
        return btn
    }()
    
    var deSelectSubject: PublishSubject = PublishSubject<Any>.init()
    var sureSubject: PublishSubject = PublishSubject<Array<String>>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_COLOR(hexStr: "#e1e1e1")
        addSubview(sureBtn)
        sureBtn.snp_makeConstraints { (make) in
            make.top.right.equalTo(self)
            make.size.equalTo(CGSize(width: 110, height: 50))
        }
        
        addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.right.equalTo(sureBtn.snp_left).offset(-10)
            make.height.equalTo(50)
        }
    }
    
    @objc func sureBtnClicked(btn: UIButton) {
        if selectIDArr?.count ?? 0 > 0 {
            self.sureSubject.onNext(selectIDArr!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GeneralSelectView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let m = dataArr?[indexPath.item]
        let cell: GeneralSelectItem = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralSelectItem", for: indexPath) as! GeneralSelectItem
        cell.portraitV.kf.setImage(with: URL(string: m!.avatar ))
        cell.titleLa.text = (m!.avatar.count > 0) ? "" : m!.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataArr?.remove(at: indexPath.item)
        self.collectionView.reloadData()
        self.deSelectSubject.onNext("")
    }
}

class GeneralSelectItem: UICollectionViewCell {
    lazy var portraitV: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        imgv.layer.cornerRadius = 20
        imgv.layer.masksToBounds = true
        return imgv
    }()
    lazy var titleLa: UILabel = {
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 14)
        la.textColor = HEX_FFF
        la.layer.cornerRadius = 20
        la.layer.masksToBounds = true
        la.textAlignment = .center
        la.adjustsFontSizeToFitWidth = true
        la.numberOfLines = 0
        return la
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_COLOR(hexStr: "#e1e1e1")
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GeneralSelectModel: BaseModel {
    var name: String = ""
    var phone: String = ""
    var avatar: String = ""
}
