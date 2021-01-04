//
//  QueryLIDownload.swift
//  Tour
//
//  Created by Narendra Pandey on 04/01/21.
//  Copyright © 2021 Narendra Pandey. All rights reserved.
//

import Foundation

class QueryTour {
    
    // MARK: - Variable -
    private let repository: DBManager<TourDetails>
    
    // MARK: - Initiallize -
    init(with repo: DBManager<TourDetails>) {
        repository = repo
    }
}

// MARK: - Query setup -
extension QueryTour {
    
    func insertList(response: TourDetails) {
        let predicate = NSPredicate(format: "self.title = %@", response.title.lowercased())
        
        let filter: [TourDetails] = try! repository.getAll(where: predicate)
        if filter.isEmpty {
            try? repository.insert(item: response)
        } else {
            try? repository.delete(item: response, with: predicate)
            //deleteSingleObject(response)
            try? repository.insert(item: response)
        }
    }
    
    func getList(where predicate: NSPredicate?) -> [TourDetails] {
        let items: [TourDetails] = try! repository.getAll(where: predicate)
        return items
    }
    
    func deleteSingleObject(_ response: TourDetails) {
        try? repository.deleteSingleObject(item: response, with: "self.id")
    }
}
