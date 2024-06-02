//
//  GameResponseDTO.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

struct GameResponseDTO: Decodable {
    let games: [GameDTO]
}

extension GameResponseDTO {
    struct GameDTO: Decodable {
        let name: String?
        let imgURL: String?
    }
}

extension GameResponseDTO.GameDTO {
    func toDomain<T: Playable>(of type: T.Type ) -> T {
        return T(answer: name, imgURL: imgURL)
    }
}

extension GameResponseDTO {
    func toDomain<T: Playable>(of type: T.Type) -> Games  {
        return .init(games: games.map{ $0.toDomain(of: type.self)})
    }
}
