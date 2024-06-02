//
//  APIEndpoints.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

struct APIEndpoints {
    static func getGames(with gameRequestDTO: GameRequestDTO) -> EndPoint<GameResponseDTO> {
        return .init(
            path: "\()/",
            method: .get
        )
    }

}
