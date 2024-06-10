//
//  DefaultGamesRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

final class DefaultSTTRepository: STTRepository {
    
    let sttEngine = STTEngine()
    let executeQueue: SpeakTransferDispatchQueue = DispatchQueue.main
    
    func startRecognition(
        completion: @escaping (STTLetters) -> Void
    ) {
        sttEngine.startEngine()
        sttEngine.runRecognizer(on: executeQueue) { text in
            guard text != "" else { return }
            let letter = STTLetters(letter: text)
            completion(letter)
        }
    }
    
    func stopRecognition() {
        
    }
}
