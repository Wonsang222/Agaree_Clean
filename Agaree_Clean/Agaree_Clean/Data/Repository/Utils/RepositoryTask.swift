//
//  RepositoryTask.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

class RepositoryTask: Cancellable {

    var networkTask: NetworkCancellable?
    var isCancelled = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
    
}
