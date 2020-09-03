//
//  EmojiViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class EmojiViewModel: BaseViewModel {
    @objc dynamic var dataArr: Array<Dictionary<String,Any>> = []
    func refreshData() {
        let path = JTBundleTool.bundle.path(forResource: "iconfont", ofType: "json")!
        let data = NSData.init(contentsOfFile: path)! as Data
        let dict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String,Any>
        let arr = dict["glyphs"] as! Array<Dictionary<String,Any>>
        dataArr = arr
        
    }
}
