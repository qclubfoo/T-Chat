//
//  Channel_db+CoreDataProperties.swift
//  T-Chat
//
//  Created by Дмитрий on 04.11.2020.
//  Copyright © 2020 DP. All rights reserved.
//
//

import Foundation
import CoreData

extension Channel_db {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Channel_db> {
        return NSFetchRequest<Channel_db>(entityName: "Channel_db")
    }
    
    convenience init(identifier: String, name: String, lastMessage: String?, lastActivity: Date?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension Channel_db {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message_db)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message_db)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
