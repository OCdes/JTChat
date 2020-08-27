//
//  SignInHeaderView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/5.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
class SignInHeaderView: UIView {
    let disposeBag = DisposeBag()
    //用户头像
    lazy var portraitV : UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    //场所名称
   lazy var merchantLa : UILabel = {
       let la = UILabel()
       la.textAlignment = NSTextAlignment.center;
       la.font = UIFont.systemFont(ofSize: 30)
       la.textColor = UIColor.white
    la.text = UserInfo.shared.placeShopName
       return la
   }()
    var viewModel:SignInViewModel?
    init(frame: CGRect, viewModel:SignInViewModel) {
        super.init(frame: frame)
        //头像背景图
//        let logoBg = UIImageView.init(image: UIImage.init(named: "portraiBg"))
//        logoBg.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth*6/25, height: kScreenWidth*6/25)
//        logoBg.center = center
//        addSubview(logoBg)
        self.viewModel = viewModel
        
        let rjLogo = UIImageView.init(image: UIImage.init(named: "rjLogo"))
        rjLogo.frame = CGRect(x: 24, y: 46.5, width: 50, height: 37)
        addSubview(rjLogo)
        
        let welcomImgV: UIImageView = UIImageView(image: UIImage(named: "welcom"))
        welcomImgV.frame = CGRect(x: 0, y: frame.height-47.5, width: 108, height: 17.5)
        welcomImgV.center.x = center.x
        addSubview(welcomImgV)
        //场所名称
        self.merchantLa.frame = CGRect(x: 0, y: welcomImgV.frame.minY-40, width: frame.width, height: 28)
        self.merchantLa.center.x = welcomImgV.center.x
        addSubview(self.merchantLa)
        
//        //头像
//        self.portraitV.frame = CGRect(x: 0, y: 0, width: logoBg.frame.width*2/3, height: logoBg.frame.width*2/3)
//        self.portraitV.center = logoBg.center
//        logoBg.addSubview(self.portraitV)
        _ = viewModel.rx.observeWeakly(String.self, "shopNameStr").subscribe(onNext: { [weak self](value) in
            self!.merchantLa.text = value
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
