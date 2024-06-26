//
//  DefaultPhotoRespository.swift
//  Agaree_Clean
//
//  Created by 황원상 on 6/8/24.
//

import Foundation

final class DefaultPhotoRespository: PhotoRepository {
    
    let service: DataTransferService
    let backgroundQueue: DataTransferDispachQueue = DispatchQueue.global(qos: .userInitiated)
    
    init(service: DataTransferService) {
        self.service = service
    }
    
    func fetchPhoto(
        path: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        let endPoint = APIEndpoints.getGuessWhoPhoto(path: path)
        let task = RepositoryTask()
        task.networkTask = service.request(with: endPoint,
                                           on: backgroundQueue,
                                           completion: { result in
            let result = result.mapError { $0 as Error }
            completion(result)
        })
        return task
    }
}
