//
//  DefaultTimerRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/10/24.
//

import Foundation

final class DefaultTimerRepository: TimerRepository {
    
    let timerService: TimerService
    
    init(timerService: TimerService = AgareeTimerService()) {
        self.timerService = timerService
    }
    
    func startTimer(
        for second: Float,
        completion: @escaping (Float, Bool) -> Void
    ) {
        timerService.startTimer(for: second, completion: completion)
    }
    
    func stopTimer() {
        timerService.stopTimer()
    }
}
