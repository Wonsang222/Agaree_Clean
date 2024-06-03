//
//  GamePhotoRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/3/24.
//

import Foundation

protocol GamePhotoRepository {
    @discardableResult
    func fetchGamePhoto(
        with imagePath: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
