//
//  GroupMemView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/6.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class GroupMemView: UIView {
    var dataArr: Array<GroupMemberModel> = [] {
        didSet {
            self.collectionView.dataArr = dataArr
        }
    }
    lazy var collectionView: GroupMemCollectView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        let cv = GroupMemCollectView.init(frame: self.bounds, collectionViewLayout: layout)
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.collectionView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GroupMemCollectView: UICollectionView {
    
    var dataArr: Array<GroupMemberModel> = [] {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        register(GroupMemItem.self, forCellWithReuseIdentifier: "GroupMemItem")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupMemCollectView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num: Int = Int((kScreenWidth-20)/50)
        return dataArr.count > num ? num : dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell: GroupMemItem = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupMemItem", for: indexPath) as! GroupMemItem
        cell.imgv.kf.setImage(with: URL(string: model.avatar), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

class GroupMemItem: BaseCollectionCell {
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

