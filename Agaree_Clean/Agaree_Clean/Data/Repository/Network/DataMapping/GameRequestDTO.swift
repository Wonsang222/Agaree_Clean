//
//  GameRequestDTO.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

struct GameRequestDTO: Encodable {
    let game: KindsOfGames
    let howMany: Int
    
    enum CodingKeys: String, CodingKey {
        case game
        case howMany
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(game.rawValue, forKey: .game)
        try container.encode(howMany, forKey: .howMany)
    }
}
