//
//  Timer.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/9/24.
//

import Foundation

protocol TimerService {
    func startTimer(
        for second:Float,
        completion: @escaping (Float, Bool) -> Void
    )
    func stopTimer()
}

final class AgareeTimerService: TimerService {
    
    private var timer: Timer? = nil
    private var isRunning: Bool? = nil
    private var progress: Float = 0.0

    func startTimer(
        for second:Float,
        completion: @escaping (Float, Bool) -> Void
    ) {

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.timer = Timer(
                timeInterval: 0.2,
                repeats: false,
                block: { [weak self] timer in
                    guard let strongSelf = self else { return }
                    
                    let speed = (1.0 / second) * 0.1
                    
                    DispatchQueue.main.async {
                        if strongSelf.progress >= 1.0 {
                            strongSelf.timer = nil
                            strongSelf.isRunning = false
                        }
                        
                        strongSelf.progress += speed
                        completion(strongSelf.progress, strongSelf.isRunning!)
                    }
            })
            RunLoop.current.add(strongSelf.timer!, forMode: .common)
            strongSelf.isRunning = true
            strongSelf.timer?.fire()
            RunLoop.current.run()
        }
    }
    
    func stopTimer() {
        timer = nil
        isRunning = nil
        progress = 0.0
    }
}
