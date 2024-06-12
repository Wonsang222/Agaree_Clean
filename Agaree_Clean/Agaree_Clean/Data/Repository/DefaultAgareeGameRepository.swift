//
//  DefaultAgareeGameRepository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/2/24.
//

import Foundation

final class DefaultAgareeGameRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispachQueue
    
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispachQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultAgareeGameRepository: 
