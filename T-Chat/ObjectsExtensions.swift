//
//  ObjectsExtensions.swift
//  T-Chat
//
//  Created by Дмитрий on 27.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
    convenience init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    var about: String {
        let name = self.name ?? "Without name"
        let identifier = self.identifier ?? "Without ID"
        let lastMessage = self.lastMessage ?? "No messages yet"
        let lastActivity: String
        if let date = self.lastActivity {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            lastActivity = formatter.string(from: date)
        } else {
            lastActivity = "No activiteis yet"
        }
        return """
        Channel name: \(name)
        ID: \(identifier)
        Last message: \(lastMessage)
        Last activity: \(lastActivity)\n
"""
    }
}

extension Message_db {
    convenience init(content: String, created: Date, senderID: String, senderName: String, channelID: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = content
        self.created = created
        self.senderID = senderID
        self.senderName = senderName
    }
}
