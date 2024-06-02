//
//  DispatchQueueType.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

protocol DispatchQueueType {
    func async(_ completion: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(_ completion: @escaping () -> Void) {
        async(execute: completion)
    }
}
