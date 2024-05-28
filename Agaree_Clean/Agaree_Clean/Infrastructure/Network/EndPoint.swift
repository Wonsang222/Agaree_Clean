//
//  EndPoint.swift
//  Agaree_Clean
//
//  Created by 황원상 on 5/28/24.
//

import Foundation

enum HttpMethod: String {
    case get = "get"
    case post = "post"
    case put = "put"
    case delete = "delete"
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data?) throws -> T
}

protocol BodyEncoder {
    func encode(_ parameters: [String : Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

protocol Requestable {
    var path: String { get }
    var method: HttpMethod { get }
    var headerParameter: [String : String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String : Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String : Any] { get }
    var bodyEncoder: BodyEncoder { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        
        let endPoint = baseURL + path
        
        guard var urlComponent = URLComponents(string: baseURL) else {
            throw RequestGenerationError.RequestGenerationError
        }
        var queryItem = [URLQueryItem]()
        
        let queries = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        
        queries.forEach {
            queryItem.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        config.queryParameters.forEach {
            queryItem.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponent.queryItems = queryItem.isEmpty ? nil : queryItem
        
        guard let url = urlComponent.url else {
            throw RequestGenerationError.RequestGenerationError
        }
    
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var headers = config.headers
        headerParameter.forEach { headers[$0] = $1 }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParameters)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}


enum RequestGenerationError: Error {
    case RequestGenerationError
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
