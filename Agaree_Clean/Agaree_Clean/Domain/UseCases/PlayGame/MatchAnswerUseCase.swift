//
//  MatchAnswerUserCase.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/17/24.
//

import Foundation

protocol MatchAnswerUseCase {
    func execute
    (
        sttLetters: String,
        answer: String
    ) -> Bool
}


