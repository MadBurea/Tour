//
//  QueryTourLocation.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//

import Foundation
import CoreData

class QueryTourLocation {
    
    // MARK: - Variable -
    private let repository: DBManager<TourLocationDetail>
    
    // MARK: - Initiallize -
    init(with repo: DBManager<TourLocationDetail>) {
        repository = repo
    }
}

// MARK: - Query setup -
extension QueryTourLocation {
    
    func insertList(response: TourLocationDetail) {
        
        var list = try! repository.getManagedObjects(with: nil)
        
        if list.count == 10 {
            list.sort { ($0.time ?? Date()) > ($1.time ?? Date()) }
            
            if let lastObject = list.last {
                try? repository.deleteObject(item: lastObject)
            }
        }
        try? repository.insert(item: response)
    }
    
    func getList(where predicate: NSPredicate?) -> [TourLocationDetail] {
        let items: [TourLocationDetail] = try! repository.getAll(where: predicate)
        return items
    }
    
    func getAllManagedObject() -> [NSManagedObject] {
        return try! repository.getManagedObjects(with: nil)
    }
}
