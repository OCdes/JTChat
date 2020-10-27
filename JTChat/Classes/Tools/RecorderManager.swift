//
//  RecorderManager.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/22.
//

import UIKit
import AVFoundation
class RecorderManager: NSObject {
    var avRecorder: AVAudioRecorder?
    var avPlayer: AVAudioPlayer?
    var avPath: String?
    func beginRecordAudio(name: String) {
        let filemanager = FileManager.default
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/recorder")
        if !filemanager.fileExists(atPath: filePath!) {
            do {
                try filemanager.createDirectory(at: URL(fileURLWithPath: filePath!), withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print("创建子文件夹失败：\(err)")
            }
            
        }
        self.avPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/recorder/\(name)\(Int((Date().timeIntervalSince1970)*1000)).wav")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord)
        } catch let err {
            print("录制类型设置失败：\(err)")
        }
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化录音session失败：\(err)")
        }
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 1600),AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM), AVLinearPCMBitDepthKey:NSNumber(value: 16), AVNumberOfChannelsKey: NSNumber(value: 1), AVEncoderAudioQualityKey:NSNumber(value: AVAudioQuality.min.rawValue)]
        
        do {
            let url = URL(fileURLWithPath: self.avPath!)
            avRecorder = try AVAudioRecorder(url: url, settings: recordSetting)
            avRecorder!.isMeteringEnabled = true
            avRecorder!.prepareToRecord()
            avRecorder!.delegate = self
            avRecorder!.record()
            print("avRecorder 开始录音,路径：\(self.avPath!)")
        } catch let err {
            print("录制音频失败：\(err)")
        }
        
    }
    
    func pauseRecorderAudio() {
        if let recorder = self.avRecorder {
            if recorder.isRecording {
                print("正在录制，将要暂停，文件路径为\(self.avPath!)")
            } else {
                print("还未录制，立即暂停")
            }
            recorder.pause()
        }
    }
    
    func resume() {
        if let recorder = self.avRecorder {
            recorder.record()
        }
    }
    
    func stopRecorderAudio(byCancle: Bool?)->String {
        if let recorder = self.avRecorder {
            if recorder.isRecording {
                print("正在结束当前的录音，文件路径为\(self.avPath!)")
            } else {
                print("还没开录，立马结束")
            }
            recorder.stop()
            if let bf = byCancle, bf == true {
//                print("因取消发送，删除录音：\(recorder.deleteRecording())")
            }
            self.avRecorder = nil
        } else {
            print("录音器未初始化")
        }
        return self.avPath!
    }
    
    func playAudio(by filepath: String) {
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending(filepath)
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path!) {
                do {
                    let session = AVAudioSession.sharedInstance()
                    try session.setCategory(.playback)
                    try session.setActive(true)
                    let url = URL(fileURLWithPath: path!)
                    self.avPlayer = try AVAudioPlayer(contentsOf: url)
                    self.avPlayer?.delegate = self
                    if let player = self.avPlayer {
                        if player.isPlaying {
                            player.stop()
                        } else {
                            print("播放录音长度：\(player.duration)")
                            player.play()
//                            var count: Double = 0
//                            _ = Timer(timeInterval: 1, repeats: true) { (t) in
//                                if count < player.duration {
//                                    count += 1
//                                } else {
//                                    t.invalidate()
//                                    self.avPlayer!.stop()
//                                    print("播放结束")
//                                }
//                            }
                        }
                    } else {
                        print("音频文件无法获取")
                    }
                } catch let err {
                    print("播放音频失败：\(err)")
                }
            } else {
                print("当前音频文件不存在")
            }
    }
    
    
    
    func stopPlayAudio(by filePath: String) {
        if let player = self.avPlayer {
            if player.isPlaying {
                print("播放器正在播放，文件路径为\(filePath)")
            } else {
                print("还没开播，立马结束")
            }
//            if player.url?.absoluteString == filePath {
                player.stop()
                self.avPlayer = nil
//            }
        } else {
            print("播放器尚未初始化")
        }
    }
}

extension RecorderManager: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//            print("回调方法，录制完成,已存入：\(self.avPath!)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("回调方法，播放完成")
    }
}
