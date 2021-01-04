//
//  DBManager.swift
//  LearningIndia
//
//  Created by Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import Foundation
import CoreData

class DBManager<RepositoryObject>: Repository
where RepositoryObject: Entity,
      RepositoryObject.StoreType: NSManagedObject,
      RepositoryObject.StoreType.EntityObject == RepositoryObject {
    
    // MARK: - Variable -
    var persistentContainer: NSPersistentContainer
    
    // MARK: - Init -
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

// MARK: - CRUD Operations -
extension DBManager {
    
    func getAll(where predicate: NSPredicate?) throws -> [RepositoryObject] {
        let objects = try getManagedObjects(with: predicate)
        return objects.compactMap { $0.model }
    }
 
    func insert(item: RepositoryObject) throws {
        persistentContainer.viewContext.insert(item.toStorable(in: persistentContainer.viewContext, withSuperClass: nil, isMediaUpate: false)!)
        saveContext()
    }
    
    func update(item: RepositoryObject) throws {
        try insert(item: item)
    }
    
    func deleteObject(item: RepositoryObject.StoreType) throws {
        persistentContainer.viewContext.delete(item)
        saveContext()
    }
    
    func delete(item: RepositoryObject, with predicate: NSPredicate?) throws {
        //        let predicate = NSPredicate(format: "\(primaryKey) == %@", item.toStorable(in: persistentContainer.viewContext, withSuperClass: nil)!.primaryKey)
        let items = try getManagedObjects(with: predicate)
        persistentContainer.viewContext.delete(items.first!)
        saveContext()
    }
    
    func deleteSingleObject(item: RepositoryObject, with primaryKey: String) throws {
        let predicate = NSPredicate(format: "\(primaryKey) == %@", item.toStorable(in: persistentContainer.viewContext, withSuperClass: nil, isMediaUpate: false)!.primaryKey)
        let items = try getManagedObjects(with: predicate)
        items.forEach { (items) in
            persistentContainer.viewContext.delete(items)
        }
        saveContext()
    }
    
    func updateMediaExpiry(item: RepositoryObject) throws {
        if item.toStorable(in: persistentContainer.viewContext, withSuperClass: nil, isMediaUpate: true) != nil {
            saveContext()
        }
    }
}

// MARK: - Core Data Saving support
extension DBManager {
    
    final private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                plog(nserror)
                // fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    final func getManagedObjects(with predicate: NSPredicate?) throws -> [RepositoryObject.StoreType] {
        let entityName = String(describing: RepositoryObject.StoreType.self)
        let request = NSFetchRequest<RepositoryObject.StoreType>(entityName: entityName)
        request.predicate = predicate
        
        return try persistentContainer.viewContext.fetch(request)
    }
}

// MARK: - Insert, Fetch Request -
extension Storable where Self: NSManagedObject {
    
    static func getOrCreateSingle(with predicate: NSPredicate?, from context: NSManagedObjectContext) -> Self {
        let result = single(with: predicate, from: context) ?? insertNew(in: context)
        return result
    }
    static func getOrCreateSingle(with primaryKey: String, from context: NSManagedObjectContext) -> Self {
        let result = single(with: primaryKey, from: context) ?? insertNew(in: context)
        return result
    }
    static func single(with primaryKey: String, from context: NSManagedObjectContext) -> Self? {
        return fetch(with: primaryKey, from: context)?.first
    }
    static func fetch(with primaryKey: String, from context: NSManagedObjectContext) -> [Self]? {
        let entityName = String(describing: Self.self)
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", primaryKey)
        fetchRequest.fetchLimit = 1
        
        let result: [Self]? = try? context.fetch(fetchRequest)
        
        return result
    }
    static func single(with predicate: NSPredicate?, from context: NSManagedObjectContext) -> Self? {
        return fetch(with: predicate, from: context)?.first
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self {
        return Self(context: context)
    }
    
    static func fetch(with predicate: NSPredicate?, from context: NSManagedObjectContext) -> [Self]? {
        let entityName = String(describing: Self.self)
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        fetchRequest.predicate = predicate
        //        fetchRequest.predicate = NSPredicate(format: "id == %@", primaryKey)
        fetchRequest.fetchLimit = 1
        
        let result: [Self]? = try? context.fetch(fetchRequest)
        
        return result
    }
}
