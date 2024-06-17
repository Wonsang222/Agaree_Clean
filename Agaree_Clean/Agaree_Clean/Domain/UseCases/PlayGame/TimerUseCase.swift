//
//  MatchAnswer.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/8/24.
//

import Foundation

protocol TimerUseCase {
    func execute(
    for second: Float,
    completion: @escaping (TimerSecond) -> Void
    )}

final class DefaultTimerUseCase: TimerUseCase {

    private let timerRepository: TimerRepository
    
    init(timerRepository: TimerRepository) {
        self.timerRepository = timerRepository
    }
    
    func execute(
        for second: Float,
        completion: @escaping (TimerSecond) -> Void
    ) {
        timerRepository.startTimer(for: second) { (second:Float, isDone:Bool) -> Void in
            let timerInfo = TimerSecond(second: second, isTimeOut: isDone)
            completion(timerInfo)
        }
    }
}
