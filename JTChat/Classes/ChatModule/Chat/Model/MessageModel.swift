//
//  MessageModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class MessageModel: BaseModel {
    /*
     CREATE TABLE [ChatLog] (
     [id] INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
     [place_id] INTEGER  NOT NULL,
     [sender] VARCHAR(16)  NOT NULL,
     [receiver] VARCHAR(16)  NOT NULL,
     [ope_id] INTEGER  NOT NULL,
     [package_type] INTEGER  NOT NULL,
     [package_content] TEXT  NOT NULL,
     [create_time] TIMESTAMP  NOT NULL,
     [topic_group] VARCHAR(32)  NULL
     )
     */
    var id: Int = 0
    var place_id: Int = 0
    var sender: String = ""
    var senderPhone: String = ""
    var senderAvanter: String = ""
    var receiver: String = ""
    var receiverPhone: String = ""
    var receiverAvanter: String = ""
    var creatTime: String = ""
    var timeStamp: TimeInterval = 0
    var msgContent: String = ""
    var packageType: Int = 0
    var topic_group: String = ""
    var estimate_height: Float = 0
    var estimate_width: Float = 0
    var isRemote: Bool = false
    var isReaded: Bool = false
    var voiceIsReaded: Bool = false
}

class MessageListModel: BaseModel {
    var id: Int = 0
    var place_id: Int = 0
    var sender: String = ""
    var senderID: String = ""
    var senderPhone: String = ""
    var senderAvanter: String = ""
    var senderDepartment: String = ""
    var receiver: String = ""
    var receiverID: String = ""
    var receiverPhone: String = ""
    var receiverAvanter: String = ""
    var receiverDepartment: String = ""
    var leasteTime: String = ""
    var leasteContent: String = ""
}
