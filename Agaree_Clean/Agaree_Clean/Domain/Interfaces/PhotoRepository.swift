//
//  PhotoRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/4/24.
//

import Foundation

protocol PhotoRepository {
    
    @discardableResult
    func fetchPhoto(
        path: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
