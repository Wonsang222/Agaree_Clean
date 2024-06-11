//
//  DataTransferService.swift
//  Agaree_Clean
//
//  Created by 황원상 on 5/29/24.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferDispachQueue {
    func asyncExecute(work: @escaping () -> Void)
}

extension DispatchQueue: DataTransferDispachQueue {
    func asyncExecute(work: @escaping () -> Void) {
        async(execute: work)
    }
}

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where T == E.Response
    
    func request<T: Decodable, E: ResponseRequestable> (
        with endpoint: E,
        on queue: DataTransferDispachQueue,
        completion: @escaping CompletionHandler<T>
    ) -> NetworkCancellable? where T == E.Response
}

final class DefaultDataTransferService {
    private let networkService: NetworkService
    private let logger: DataTransferErrorLogger
    private let resolver: DataTransferErrorResolver
    
    init(
        networkService: NetworkService,
        logger: DataTransferErrorLogger = DefaultDataTransferErrorLogger(),
        resolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver()
    ) {
        self.networkService = networkService
        self.logger = logger
        self.resolver = resolver
    }
    
    private func decode<T: Decodable>(
        _ data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, DataTransferError> {
        do {
            guard let data = data else {return .failure(.noResponse)}
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.logger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.resolver.resolve(error: error)
        return resolvedError is NetworkError
        ? .networkFailure(error)
        : .resolvedNetworkFailure(resolvedError)
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T, E>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T : Decodable, T == E.Response, E : ResponseRequestable {
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
    }
    
    func request<T, E>(with endpoint: E, on queue: DataTransferDispachQueue, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T : Decodable, T == E.Response, E : ResponseRequestable {
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data, decoder: endpoint.responseDecoder)
                queue.asyncExecute {
                    completion(result)
                }
            case .failure(let err):
                let error = self.resolve(networkError: err)
                queue.asyncExecute {
                    completion(.failure(error))
                }
            }
        }
    }
}


//MARK: - Logger

protocol DataTransferErrorLogger {
    func log(error: Error)
}

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    
    func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

//MARK: - Error Resolver

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error {
        return error
    }
}


//MARK: - Decoder

class JSONResponseDecoder: ResponseDecoder {
    let decoder = JSONDecoder()
    func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}

class RawDataResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
