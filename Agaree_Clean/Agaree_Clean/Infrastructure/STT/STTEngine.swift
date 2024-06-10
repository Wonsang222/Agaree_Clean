//
//  STTEngine.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/4/24.
//

import Foundation
import Speech
import AVFoundation

protocol SpeakTransferDispatchQueue {
    func asyncExecuteForSTT(work: @escaping () -> Void)
}

extension DispatchQueue: SpeakTransferDispatchQueue {
    func asyncExecuteForSTT(work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}

final class STTEngine {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let executeQueue: SpeakTransferDispatchQueue = DispatchQueue.main
    
    func startEngine()  {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else {
                fatalError()
            }
            recognitionRequest.shouldReportPartialResults = true
        } catch {
                
        }
    }
    
    func offEngine() {
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    func runRecognizer(
        on queue: SpeakTransferDispatchQueue,
        completion: @escaping (String) -> Void
    ) {
            if self.audioEngine.isRunning {
                removeAudioTasks()
            } else {
              startRecording(on: queue, completion: completion)
            }
        }
    
    private func startRecording(
        on queue: SpeakTransferDispatchQueue,
        completion: @escaping (String) -> Void
    ) {
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
        }
        
        let inputNode = self.audioEngine.inputNode
        guard let recognitionRequest = self.recognitionRequest else { return }
        self.recognitionTask = self.speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            
              var isFinal = false
              
              if result != nil {
                  let text = result?.bestTranscription.formattedString
                  guard let text = text else { return }
                  queue.asyncExecuteForSTT {
                      completion(text)
                  }
                  isFinal = (result?.isFinal)!
              }
              
              if error != nil || isFinal {
                  self?.audioEngine.stop()
                  inputNode.removeTap(onBus: 0)
                  
                  self?.recognitionRequest = nil
                  self?.recognitionTask = nil
              }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch { }
    }
    
    private func removeAudioTasks() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.audioEngine.inputNode.removeTap(onBus: 0)
    }
}
