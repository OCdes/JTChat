//
//  LabelScrollView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/3.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class LabelScrollView: UIScrollView {
    init(frame: CGRect, num: ()->Int, labelOfIndex: (_ index : Int)->(UILabel) ) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        
        //实例化 scrollview 并且指定位置
        backgroundColor = UIColor.lightGray
        //执行闭包获取标签数量
        let count = num()
        print("标签数量 \(count)")
        //遍历 count，标签内容，添加到 scrollview
        let margin: CGFloat = 8.0
        var x = margin
        for i in 0..<count {
            let label = labelOfIndex(i)
            label.frame = CGRect(x: x, y: 0.0, width: label.bounds.width, height: frame.height)
            addSubview(label)
            x += label.bounds.width+margin;
        }
        //返回 scrollview
        contentSize = CGSize(width: x + margin, height: frame.height)
        showsHorizontalScrollIndicator = false
    
    }
    //自定义视图中必须要实现的方法
    required init?(coder: NSCoder) {
    //fatalError 函数会让用 storyboard 开发直接崩掉
    fatalError("init(coder:) has not been implemented")
    }
    func scrollView(frame: CGRect, num: ()->Int, labelOfIndex: (_ index : Int)->(UILabel)) -> UIScrollView {
        //实例化 scrollview 并且指定位置
        let sv = UIScrollView(frame: frame)
        sv.backgroundColor = UIColor.lightGray
        //执行闭包获取标签数量
        let count = num()
        print("标签数量 \(count)")
        //遍历 count，标签内容，添加到 scrollview
        let margin: CGFloat = 8.0
        var x = margin
        for i in 0..<count {
            let label = labelOfIndex(i)
            label.frame = CGRect(x: x, y: 0.0, width: label.bounds.width, height: frame.height)
            sv.addSubview(label)
            x += label.bounds.width+margin;
        }
        //返回 scrollview
        sv.contentSize = CGSize(width: x + margin, height: frame.height)
        sv.showsHorizontalScrollIndicator = false
        return sv
    }


}
