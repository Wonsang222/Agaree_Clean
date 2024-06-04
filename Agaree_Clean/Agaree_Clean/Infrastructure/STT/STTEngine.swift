//
//  STTEngine.swift
//  Agaree_Clean
//
//  Created by 위사모바일 on 6/4/24.
//

import Foundation
import Speech
import AVFoundation

final class STTEngine {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    func startRecognition(
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            
        }
        
    }
    
}
