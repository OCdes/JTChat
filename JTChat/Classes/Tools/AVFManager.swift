//
//  AVFManager.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/22.
//

import UIKit
import AVFoundation

class AVFManager: NSObject {
    
    func audioTransToData(with filePath: String) -> Data {
        let fPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending(filePath)
            let amrPath = NSTemporaryDirectory().appending(filePath)
            if NTYAmrCoder.encodeWavFile(fPath!, toAmrFile: amrPath) {
                return NSData(contentsOfFile: amrPath)! as Data
            } else {
                print("发送时wav转换amr失败")
                return Data()
            }
    }
    
    func durationOf(filePath path: String) -> Int {
        let filemanager = FileManager.default
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/recorder")
        if !filemanager.fileExists(atPath: filePath!) {
            do {
                try filemanager.createDirectory(at: URL(fileURLWithPath: filePath!), withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print("创建子文件夹失败：\(err)")
            }
            
        }
        let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending(path)
        var duration: Int = 0
        do {
            let avasset = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: creatPath!))
            duration = Int(ceil(avasset.duration))
        } catch let err {
            print("读取音频失败:\(err)")
        }
        return duration
    }
    
    func saveAudio(audioDataStr: String ,fromUserId: String)->String {
        let filemanager = FileManager.default
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/recorder")
        
        if !filemanager.fileExists(atPath: filePath!) {
            do {
                try filemanager.createDirectory(at: URL(fileURLWithPath: filePath!), withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print("创建子文件夹失败：\(err)")
            }
            
        }
        
        let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/recorder/\(fromUserId)\(JTManager.manager.phone)\(Int((Date().timeIntervalSince1970)*1000)).wav")
        let tmpPath = NSTemporaryDirectory().appending("/\(fromUserId)\(JTManager.manager.phone)\(Int((Date().timeIntervalSince1970)*1000)).amr")
        let data = Data.init(base64Encoded: audioDataStr)
        if let imgdata = data {
            if !filemanager.fileExists(atPath: tmpPath) {
                if filemanager.createFile(atPath: tmpPath, contents: imgdata, attributes: nil) {
                    print("amr创建成功")
                } else {
                    print("amr创建失败，路径为=\(tmpPath)")
                }
            }
            if !filemanager.fileExists(atPath: creatPath!) {
                if NTYAmrCoder.decodeAmrFile(tmpPath, toWavFile: creatPath!) {
                    if filemanager.createFile(atPath: creatPath!, contents: imgdata, attributes: nil) {
                        print("创建成功")
                    } else {
                        print("创建失败，语音文件路径=\(creatPath!)")
                    }
                } else {
                    print("arm转换wav失败")
                }
                
            }
            
            
        }
        return ((creatPath ?? "") as NSString).components(separatedBy: "/Caches").last ?? ""
    }
}
