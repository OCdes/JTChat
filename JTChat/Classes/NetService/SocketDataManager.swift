//
//  SocketDataManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/5/25.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

enum EventType: Int32 {
    case EventTypeDefault = 0
    case EventTypeLineChat = 1//点对点聊天
    case EventTypeGroupChat //讨论组广播
    case EventTypePrewarning//预警推送
    case EventTypeApproval//审批推送
    case EventTypePop //弹窗警告
    case EventTypeOutSign//其它端登录推送
}

enum PackageType: Int32 {
    case PackageTypeInitial = 0//初始化用户数据
    case PackageTypeData //数据包
    case PackageTypeEnd //结束包
    case PackageTypeHeartBeat//心跳包
}

enum TransType: Int32 {
    case TransTypeByteStream = 1
    case TransTypeFileStream
}

class SocketDataManager: NSObject {
    var length: String = ""
    var fromUserId: String = ""
    var targetUserId: String = ""
    var eventType: EventType = .EventTypeDefault
    var packageType: PackageType = .PackageTypeInitial
    var transType: TransType = .TransTypeByteStream
    var placeId: Int = 0
    var fileSuffix: String = ""
    var contentString = ""
    var contentData: Data = Data()
    var packageLength: Int = 0
    override init() {
        super.init()
    }
    
    func strToBytes(str: String, lengtch: Int)->Data {
        let data = str.data(using: String.Encoding.utf8)
        var bytes = [UInt8](repeating: 0, count: lengtch)
        data?.copyBytes(to: &bytes, count: data!.count)
        return Data.init(bytes: bytes, count: lengtch)
    }
    
    func intByBytes(byte:[UInt8])->Int {
        var returnValue: UInt32 = 0
        let data = NSData.init(bytes: byte, length: byte.count)
        data.getBytes(&returnValue, length: byte.count)
        returnValue = UInt32(bigEndian:returnValue)
        return Int(returnValue)
    }
    
    func intToData(int: Int)->Data {
        let UInt = UInt32.init(Double.init(int))
        var bytes = [Int8(truncatingIfNeeded: UInt >> 24),
        Int8(truncatingIfNeeded: UInt >> 16),
        Int8(truncatingIfNeeded: UInt >> 8),
        Int8(truncatingIfNeeded: UInt)]
        
        let data = Data.init(bytesNoCopy: &bytes, count: 4, deallocator: Data.Deallocator.none)
        return data
    }
    
    func dataToInt(data: NSData)->Int {
        var returnValue: UInt32 = 0
        data.getBytes(&returnValue, length: 4)
        returnValue = UInt32(bigEndian:returnValue)
        return Int(returnValue)
    }
    
    func bytesToStr(bytes: [UInt8], length: Int)->String {
        let data = Data.init(bytes: bytes, count: length)
        guard var str = String.init(data: data, encoding: String.Encoding.utf8) else { return "" }
        repeat {
            let s = (str as NSString).replacingCharacters(in: NSRange(location: str.count-1, length: 1), with: "")
            str = s
            if !s.hasSuffix("\0") {
                print("++++++++++++\(s)")
                break
            }
        } while str.hasSuffix("\0")
        print("++++++++++++\(str)-----length\(str.count)")
        return str
    }
    
    func getFullData() -> Data {
        var data = Data()
        let fromUserIDData = strToBytes(str: fromUserId, lengtch: 16)
        let targetUserIDData = strToBytes(str: targetUserId, lengtch: 16)
        let eventTypeData = intToData(int: Int(eventType.rawValue))
        let packageTypeData = intToData(int: Int(packageType.rawValue))
        let transTypeData = intToData(int: Int(transType.rawValue))
        let placeIDData = intToData(int: placeId)
        let suffixData = strToBytes(str: fileSuffix, lengtch: 4)
        var contentData = contentString.data(using: .utf8)
        if transType == .TransTypeFileStream {
            contentData = Data.init(base64Encoded: contentString)
        }
        var length = CFSwapInt32BigToHost(UInt32((contentData?.count ?? 0)))
        let contentLengthData = NSData.init(bytesNoCopy: &length, length: 4, freeWhenDone: false)
        data.append(fromUserIDData)
        data.append(targetUserIDData)
        data.append(eventTypeData)
        data.append(packageTypeData)
        data.append(placeIDData)
        data.append(suffixData)
        data.append(transTypeData)
        data.append(contentLengthData as Data)
        data.append(contentData!)
        var dataLength = CFSwapInt32BigToHost(UInt32(data.count))
        var dataLengthData = Data.init(bytes: &dataLength, count: 4)
        dataLengthData.append(data)
        return dataLengthData
    }
    
    func unpackageData(data: Data) {
        var nextReadLength = 4
        var startIndex = 0
        if data.count > nextReadLength {
            var flag = true
            while true {
                let lengthData = data.subdata(in: 0..<4)
                if flag {
                    packageLength = dataToInt(data: lengthData as NSData)
                    flag = false
                    startIndex = nextReadLength
                    nextReadLength = packageLength
                } else {
                    var fromUserIDBytes = [UInt8](repeating: 0, count:16)
                    var targetUserIDBytes = [UInt8](repeating: 0, count:16)
                    var eventTypeBytes = [UInt8](repeating: 0, count:4)
                    var packageTypeBytes = [UInt8](repeating: 0, count:4)
                    var transTypeBytes = [UInt8](repeating: 0, count:4)
                    var placeIdBytes = [UInt8](repeating: 0, count:4)
                    var fileSuffixBytes = [UInt8](repeating: 0, count:4)
                    var packageBodyLengthBytes = [UInt8](repeating: 0, count:4)
                    data.copyBytes(to: &fromUserIDBytes, from: startIndex..<16+startIndex)
                    data.copyBytes(to: &targetUserIDBytes, from: startIndex+16..<startIndex+32)
                    data.copyBytes(to: &eventTypeBytes, from: startIndex+32..<startIndex+36)
                    data.copyBytes(to: &packageTypeBytes, from: startIndex+36..<startIndex+40)
                    data.copyBytes(to: &placeIdBytes, from: startIndex+40..<startIndex+44)
                    data.copyBytes(to: &fileSuffixBytes, from: startIndex+44..<startIndex+48)
                    data.copyBytes(to: &transTypeBytes, from: startIndex+48..<startIndex+52)
                    data.copyBytes(to: &packageBodyLengthBytes, from: startIndex+52..<startIndex+56)
                    let dataData = data.subdata(in: startIndex+56..<data.count)
                    fromUserId = bytesToStr(bytes: fromUserIDBytes, length: 16)
                    targetUserId = bytesToStr(bytes: targetUserIDBytes, length: 16)
                    eventType = EventType(rawValue: Int32(intByBytes(byte: eventTypeBytes))) ?? EventType(rawValue: 0)!
                    packageType = PackageType(rawValue: Int32(intByBytes(byte: packageTypeBytes))) ?? PackageType(rawValue: 0)!
                    placeId = intByBytes(byte: placeIdBytes)
                    fileSuffix = bytesToStr(bytes: fileSuffixBytes, length: 4)
                    transType = Int32(intByBytes(byte: transTypeBytes)) == 1 ? TransType.TransTypeByteStream : TransType.TransTypeFileStream
                    var contentStr = String.init(data: dataData, encoding: .utf8)
                    if transType == .TransTypeFileStream {
                        contentStr = dataData.base64EncodedString()
                    }
                    contentString = contentStr ?? ""
                    break
                }
            }
        }
        
    }
}
