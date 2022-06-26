//
//  URLRequestBuilder.swift
//  Mercury-Store
//
//  Created by mac hub on 22/05/2022.
//

import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: URL { get }
    var requestURL: URL { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var urlRequest: URLRequest { get }
}

extension URLRequestBuilder {
    
    var baseURL: URL {
        return ApplicationEnviroment.baseURL
    }
    
    var requestURL: URL {
        return baseURL.appendingPathComponent(path, isDirectory: false)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        let header = HTTPHeaders([
            "X-Shopify-Access-Token": "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",
            "Content-Type": "application/json"
        ])
        return header
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.httpShouldHandleCookies = false
        headers.forEach { request.addValue($0.name, forHTTPHeaderField: $0.value)}
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
