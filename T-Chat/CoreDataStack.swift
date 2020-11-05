//
//  CoreDataStack.swift
//  T-Chat
//
//  Created by Дмитрий on 27.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    var isPrinted: Bool = false
    private var storeURL: URL = {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Can't access to document directory")
        }
        let storeURL = documentDirectory.appendingPathComponent("Chat.sqlite")
        return storeURL
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtencion = "momd"
    
    // MARK: init CoreData stack
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtencion) else { fatalError("Can't find managed object model") }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Can't create model")}
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            fatalError("Can't create persistent store")
        }
        return coordinator
    }()
    
    // MARK: Contexts
    
    private lazy var writerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.mergePolicy = NSOverwriteMergePolicy
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writerContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: Save context methods
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                } catch {
                    print("ObtainPermanentID error")
                }
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent {
            performSave(in: parent)
        }
    }
    
    // MARK: CoreData observers
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            if inserts.count > 0 {
                print("Inserted \(inserts.count) objects in data base")
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            if updates.count > 0 {
                print("Updated \(updates.count) objects in data base")
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            if deletes.count > 0 {
                print("Deleted \(deletes.count) objects in data base")
            }
        }
    }
    
    func printDataBaseStatistice() {
        mainContext.perform {
            guard let channelsFetchResult = try? self.mainContext.fetch(Channel_db.fetchRequest()) as? [Channel_db] else { return }
            print("\nThere are \(channelsFetchResult.count) channels saved in store")
            
// Uncomment for getting info about each saved channel
//            channelsFetchResult.forEach { print($0.about) }
            
            guard let messagesFetchResult = try? self.mainContext.fetch(Message_db.fetchRequest()) as? [Message_db] else { return }
            print("There are \(messagesFetchResult.count) messages saved in store\n")
        }
    }
}
