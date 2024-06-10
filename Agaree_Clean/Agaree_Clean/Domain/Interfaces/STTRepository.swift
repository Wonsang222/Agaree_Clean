//
//  STTRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/4/24.
//

import Foundation

protocol STTRepository {
    
    func startRecognition(
        completion: @escaping (STTLetters) -> Void
    )
    
    func stopRecognition()
}
