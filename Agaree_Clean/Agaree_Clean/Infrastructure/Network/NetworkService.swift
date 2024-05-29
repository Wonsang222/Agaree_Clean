//
//  DataTransferError.swift
//  Agaree_Clean
//
//  Created by 황원상 on 5/29/24.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable {}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(response data: Data?, response: URLResponse?)
    func log(error: Error)
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> any NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request,
                                              completionHandler: completion)
        task.resume()
        return task
    }
}

final class DefaultNetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        return sessionManager.request(request) { data, resp, err in
            if let err = err {
                var networkError: NetworkError
                if let resp = resp as? HTTPURLResponse {
                    networkError = .error(statusCode: resp.statusCode, data: data)
                } else {
                    networkError = self.resolve(error: err)
                }
                self.logger.log(error: networkError)
            } else {
                self.logger.log(response: data, response: resp)
                completion(.success(data))
            }
        }
        logger.log(request: request)
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {

    func request(
        endpoint: Requestable,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable? {
        do {
            let req = try endpoint.urlRequest(with: config)
            return request(request: req, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(response data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("\(error)")
    }
}

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}

