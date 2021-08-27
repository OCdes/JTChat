//
//  JTBundleTool.swift
//  Alamofire
//
//  Created by LJ on 2020/9/1.
//

import UIKit

public class JTBundleTool {
    static var bundle: Bundle = {
        let bundle = Bundle.init(path: Bundle.init(for: JTBundleTool.self).path(forResource: "JTChat", ofType: "bundle", inDirectory: nil)!)
        return bundle!
    }()
    
    public static func getBundleImg(with name: String)->UIImage? {
        var image: UIImage?
        let nstr = kIsFlagShip ? "\(name)Gold" : name
        if #available(iOS 13.0, *) {
            if let img = UIImage(named: nstr, in: bundle, with: nil) {
                image = img
            } else {
                image = UIImage(named: name, in: bundle, with: nil)
            }
        } else {
            // Fallback on earlier versions
            if let img = UIImage.init(named: nstr, in: bundle, compatibleWith: nil) {
                image = img
            } else {
                image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
            }
        }
        if image == nil {
            if let img = UIImage(named: nstr) {
                image = img
            } else {
                image = UIImage(named: name)
            }
        }
        return image
    }
}
