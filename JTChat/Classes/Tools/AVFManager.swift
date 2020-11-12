//
//  AVFManager.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/22.
//

import UIKit
import AVFoundation
import AVKit

class AVFManager: NSObject {
    
    func audioTransToData(with filePath: String) -> Data {
        let fPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending(filePath)
        let fileName = ((filePath as NSString).replacingOccurrences(of: ".wav", with: ".amr") as NSString).replacingOccurrences(of: "/recorder/", with: "")
        let amrPath = NSTemporaryDirectory().appending(fileName)
        let filemanager = FileManager.default
        if XKLIMVoiceConverter.xklim_convertWav(toAmr: fPath!, amrSavePath: amrPath) > 0 {
            let data = NSData(contentsOfFile: amrPath)! as Data
            let wavData = XKLIMVoiceConverter.xklim_decodeAMR(toWAVE: data)
            filemanager.createFile(atPath: fPath!, contents: wavData, attributes: nil)
            RecorderManager().playAudio(by: (fPath! as NSString).components(separatedBy: "/Caches").last!)
            return data
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
        let tmpPath = NSTemporaryDirectory().appending("\(fromUserId)\(JTManager.manager.phone)\(Int((Date().timeIntervalSince1970)*1000)).amr")
        let data = Data.init(base64Encoded: audioDataStr)
        if let imgdata = data {
            if !filemanager.fileExists(atPath: tmpPath) {
                if filemanager.createFile(atPath: tmpPath, contents: imgdata, attributes: nil) {
                    print("amr创建成功, 路径为=\(tmpPath)")
                } else {
                    print("amr创建失败，路径为=\(tmpPath)")
                }
            }
            if !filemanager.fileExists(atPath: creatPath!) {
                if XKLIMVoiceConverter.xklim_convertAmr(toWav: tmpPath, wavSavePath: creatPath!) > 0 {
                        print("转换成功，语音文件路径=\(creatPath!)")
                } else {
                    print("arm转换wav失败")
                }
            }
        }
        return ((creatPath ?? "") as NSString).components(separatedBy: "/Caches").last ?? ""
    }
    
    
    func videoData(filePath: String) -> Data {
        let fPath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(filePath)"))
        if let data = NSData(contentsOfFile: fPath!) {
            return data as Data
        } else {
            print("当前视频获取失败，路径为\(fPath!)")
            return Data()
        }
    }
    
    func firstFrameOfVideo(filePath: String, size: CGSize, toImgView: UIImageView) -> UIImage {
        DispatchQueue.global().async {
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(filePath)")
             let url = URL(fileURLWithPath: path!)
                let urlAsset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey:NSNumber(value: false)])
                let gene = AVAssetImageGenerator.init(asset: urlAsset)
                gene.appliesPreferredTrackTransform = true
                gene.maximumSize = size
                do {
                    var actualTime = CMTimeMake(value: 10, timescale: 10)
                    let img = try gene.copyCGImage(at: CMTimeMake(value: 0, timescale: 600), actualTime: &actualTime)
                    DispatchQueue.main.async {
                        toImgView.image = UIImage.init(cgImage: img)
                    }
                } catch let err {
                    DispatchQueue.main.async {
                        toImgView.image = UIImage.imageWith(color: HEX_COLOR(hexStr: "#e6e6e6"))
                    }
                    print("截取第一贞失败：\(err.localizedDescription)")
                }
        }
        return JTBundleTool.getBundleImg(with: "placeHolder") ?? UIImage()
    }
    
    func sizeOfVideo(filePath: String) -> CGSize {
        var size: CGSize = CGSize.zero
        let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(filePath)")
        let asset = AVURLAsset(url: URL(fileURLWithPath: creatPath!))
        let arr = asset.tracks
        for track in arr {
            if track.mediaType == .video {
                size = track.naturalSize
            }
        }
        print("当前视频的宽高：\(size)")
        return size
    }
    
    func durationOfVedio(filePath: String) -> Int {
        let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("\(filePath)")
        let asset = AVURLAsset(url: URL(fileURLWithPath: creatPath!))
        let time = asset.duration
        let seconds = Double(time.value)/Double(time.timescale)
        return Int(ceil(seconds))
    }
    
    func saveVideo(videoDataStr: String ,fromUserId: String) -> String {
        let filemanager = FileManager.default
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/video")
        
        if !filemanager.fileExists(atPath: filePath!) {
            do {
                try filemanager.createDirectory(at: URL(fileURLWithPath: filePath!), withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print("创建子文件夹失败：\(err)")
            }
            
        }
        
        let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/video/\(fromUserId)\(JTManager.manager.phone)\(Int((Date().timeIntervalSince1970)*1000)).mp4")
        //        let tmpPath = NSTemporaryDirectory().appending("/\(fromUserId)\(JTManager.manager.phone)\(Int((Date().timeIntervalSince1970)*1000)).amr")
        let data = Data.init(base64Encoded: videoDataStr)
        if let imgdata = data {
            //            if !filemanager.fileExists(atPath: tmpPath) {
            //                if filemanager.createFile(atPath: tmpPath, contents: imgdata, attributes: nil) {
            //                    print("amr创建成功")
            //                } else {
            //                    print("amr创建失败，路径为=\(tmpPath)")
            //                }
            //            }
            if !filemanager.fileExists(atPath: creatPath!) {
                //                if NTYAmrCoder.decodeAmrFile(tmpPath, toWavFile: creatPath!) {
                if filemanager.createFile(atPath: creatPath!, contents: imgdata, attributes: nil) {
                    print("创建成功")
                } else {
                    print("创建失败，视频文件路径=\(creatPath!)")
                }
                //                } else {
                //                    print("arm转换wav失败")
                //                }
                
            }
            
            
        }
        return ((creatPath ?? "") as NSString).components(separatedBy: "/Caches/").last ?? ""
    }
    
    func saveLocalVideo(tmpPath: String) -> String {
        let filemanager = FileManager.default
        if let tmpName = (tmpPath as NSString).components(separatedBy: "tmp/").last {
            let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/video/")
            
            if !filemanager.fileExists(atPath: filePath!) {
                do {
                    try filemanager.createDirectory(at: URL(fileURLWithPath: filePath!), withIntermediateDirectories: true, attributes: nil)
                } catch let err {
                    print("创建子文件夹失败：\(err.localizedDescription)")
                }
                
            }
            let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/video/\(tmpName)")
            if !filemanager.fileExists(atPath: creatPath!) {
                let tpp = NSTemporaryDirectory().appending("\(tmpName)")
                if let data = NSData(contentsOfFile: tpp) {
                    if filemanager.createFile(atPath: creatPath!, contents: data as Data, attributes: nil) {
                        print("本地视频存储缓存成功")
                        return ((creatPath ?? "") as NSString).components(separatedBy: "/Caches/").last ?? ""
                    }
                } else {
                    print("临时视频文件不存在")
                }
            } else {
                print("当前视频文件已存在")
            }
        }
        
        return ""
    }
}
