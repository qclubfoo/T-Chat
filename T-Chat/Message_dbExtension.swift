//
//  ObjectsExtensions.swift
//  T-Chat
//
//  Created by Дмитрий on 27.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import Foundation
import CoreData

extension Message_db {
    convenience init(content: String, created: Date, senderID: String, senderName: String, channelID: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
}
