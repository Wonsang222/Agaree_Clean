//
//  TimerRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/10/24.
//

import Foundation

protocol TimerRepository {
    func startTimer(for second: Float,
                    completion: @escaping (Float, Bool) -> Void
    )
    func stopTimer()
}
