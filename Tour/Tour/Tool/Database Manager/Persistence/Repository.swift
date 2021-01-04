//
//  Repository.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CRUD Functions -
protocol Repository {
    associatedtype EntityObject: Entity
    
    func getAll(where predicate: NSPredicate?) throws -> [EntityObject]
    func insert(item: EntityObject) throws
    func update(item: EntityObject) throws
    func delete(item: EntityObject, with predicate: NSPredicate?) throws
}

// MARK: - Get repo's Entity -
extension Repository {
    func getAll() throws -> [EntityObject] {
        return try getAll(where: nil)
    }
}

// MARK: - Convert to storable type -
protocol Entity {
    associatedtype StoreType: Storable
    
    func toStorable(in context: NSManagedObjectContext,
                    withSuperClass superClass: NSManagedObject?,
                    isMediaUpate: Bool) -> StoreType?
}

// MARK: - get Storable Data -
protocol Storable {
    associatedtype EntityObject: Entity
    
    var model: EntityObject { get }
    var primaryKey: String { get }
}

