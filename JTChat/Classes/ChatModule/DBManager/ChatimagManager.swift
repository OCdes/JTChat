//
//  ChatimagManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/7.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import CommonCrypto
class ChatimagManager: NSObject {
    private var fileManager = FileManager.default
    static let manager = ChatimagManager()
    
    func GetImageBy(MD5Str: String) -> UIImage {
        let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let creatPath = docuPath + "/images"  + "/\(MD5Str)"
        if fileManager.fileExists(atPath: creatPath) {
            return UIImage.init(contentsOfFile: creatPath)!
        } else {
            print("ChatimgDataManager----Error:图片存取异常\(MD5Str)")
            return UIImage()
        }
    }
    
    func GetImageDataBy(MD5Str: String) -> Data {
        let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let creatPath = docuPath + "/images" + "/\(MD5Str)"
        if fileManager.fileExists(atPath: creatPath) {
            return try! NSData.init(contentsOfFile: creatPath) as Data
        } else {
            print("ChatimgDataManager----Error:图片存取异常\(MD5Str)")
            return Data()
        }
    }
    
    
    
    func saveImage(image:UIImage) {
        let idata = image.jpegData(compressionQuality: 1.0)
        if let imgdata = idata {
            let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            let creatPath = docuPath + "/images"
            if !fileManager.fileExists(atPath: creatPath) {
                try! fileManager.createDirectory(atPath: creatPath, withIntermediateDirectories: true, attributes: [:])
            }
            if fileManager.createFile(atPath: "\(creatPath)/\(MD5By(data: imgdata))", contents: imgdata, attributes: nil) {
                print("创建成功")
            } else {
                print("创建失败，creatPath=\(creatPath), imagePath=\(creatPath)/\(MD5By(data: imgdata))")
            }
        }
    }
    
    func saveImage(imageDataStr: String)-> String {
        let data = Data.init(base64Encoded: imageDataStr)
        if let imgdata = data {
            let docuPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            let creatPath = docuPath + "/images"
            if !fileManager.fileExists(atPath: creatPath) {
                try! fileManager.createDirectory(atPath: creatPath, withIntermediateDirectories: true, attributes: [:])
            }
            if fileManager.createFile(atPath: "\(creatPath)/\(MD5By(data: imgdata))", contents: imgdata, attributes: nil) {
                print("创建成功")
                return MD5By(data: imgdata)
            } else {
                return ""
                print("创建失败，creatPath=\(creatPath), imagePath=\(creatPath)/\(MD5By(data: imgdata))")
            }
        }
        return ""
    }
    
    func MD5StrBy(image: UIImage)->String {
        
        let data = image.jpegData(compressionQuality: 1.0)
        if let d = data {
            return MD5By(data: d)
        } else {
            return ""
        }
    }
    
    func MD5StrBy(imageDataStr: String)->String {
        let data = Data.init(base64Encoded: imageDataStr)
        if let d = data {
            return MD5By(data: d)
        } else {
            return ""
        }
        
    }
    
    func MD5By(data: Data)->String {
        var bytes = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5([UInt8](data), CC_LONG(data.count), &bytes)
        let str = bytes.reduce("") { $0 + String(format:"%02X", $1) }
        return str
    }
}
