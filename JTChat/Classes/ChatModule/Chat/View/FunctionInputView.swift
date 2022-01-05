//
//  FunctionInputView.swift
//  JTChat
//
//  Created by jingte on 2022/1/5.
//

import UIKit
import RxSwift
class FunctionInputView: UIInputView {
    let keyheight = kScreenWidth-90
    let functionHeight = kScreenWidth-90
    var subject: PublishSubject<String> = PublishSubject<String>()
    lazy var collectionView: FunctionCollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: (kScreenWidth-110)/4, height: (self.functionHeight-75)/2)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 30, left: layout.minimumInteritemSpacing, bottom: 15, right: layout.minimumInteritemSpacing)
        let cv = FunctionCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        return cv
    }()
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        creatUI()
    }
    
    func creatUI() {
        backgroundColor = kIsFlagShip ? HEX_COLOR(hexStr: "#262a32") : HEX_COLOR(hexStr: "#F5F5F5")
        collectionView.backgroundColor = kIsFlagShip ? HEX_COLOR(hexStr: "#262a32") : HEX_COLOR(hexStr: "#F5F5F5")
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
