//
//  GamePlayUseCase.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/9/24.
//

import Foundation

protocol GamePlayUseCase {
    
    var gameTime:Float { get }
    var targetCharacter: GuessWho { get }
    var targetCharacters: [GuessWho] { get }
    var STTText: STTLetters { get }
    
    func startCounter()
    func isAnswer(
        with character: GuessWho,
        and text: STTLetters
    ) -> Bool
    func nextChracter()
    func fetchGameData(
        completion: @escaping (Result<GuessWho, Error>) -> Void
    )
}
