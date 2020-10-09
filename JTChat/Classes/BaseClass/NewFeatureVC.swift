//
//  NewFeatureVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/14.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class NewFeatureVC: BaseViewController {
    lazy var collectionView: NewFeatureCollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: kScreenWidth, height: kScreenHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = NewFeatureCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        // Do any additional setup after loading the view.
    }


}

class NewFeatureCollectionView: BaseCollectionView {

    var dataArr: Array<String> = ["n1.jpg","n2.jpg","n3.jpg"]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(NewFeatureItem.self, forCellWithReuseIdentifier: "NewFeatureItem")
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewFeatureCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewFeatureItem = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFeatureItem", for: indexPath) as! NewFeatureItem
        cell.imgv.image = JTBundleTool.getBundleImg(with: dataArr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "", for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.dataArr.count-1 {
            USERDEFAULT.set(true, forKey: "newfeature")
            RootConfig.setRootController()
        }
    }
    
}

class NewFeatureItem: BaseCollectionCell {
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
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

