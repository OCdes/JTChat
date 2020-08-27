//
//  UDIDManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/16.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import KeychainSwift
class UDIDManager: NSObject {
    open class func getUDID()->String {
        let keychain = KeychainSwift()
        
        if let UDID = keychain.get("keyChain") {
            return UDID
        } else {
            let UDID = UIDevice.current.identifierForVendor!.uuidString
            keychain.set(UDID, forKey: "keyChain")
            return UDID
        }
    }
}
