//
//  GameRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

protocol GameRepository {
    @discardableResult
    func fetchGame(
        gameQuery: GameQuery,
        completion: @escaping (Result<GuessWho, Error>) -> Void
    ) -> Cancellable?
    
    @discardableResult
    func fetchPhoto(
        path: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable?
}
