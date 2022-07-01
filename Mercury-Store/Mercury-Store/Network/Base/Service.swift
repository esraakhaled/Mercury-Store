//
//  Service.swift
//  Mercury-Store
//
//  Created by mac hub on 23/05/2022.
//

import Alamofire
import RxSwift
import Foundation

extension DataResponse {
    
    enum Errors: Error {
        case unKnown
    }
    
    var inputDataNil: Error {
        guard let _ = self.error else {
            return Errors.unKnown
        }
        return AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength)
    }
    
}

class NetworkService {
    func execute<T: Codable>(_ urlRequest: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlRequest).responseData { (response) in
                switch response.result {
                case .success(let data):
                    do {
                        let item = try newJSONDecoder().decode(T.self, from: data)
                        observer.onNext(item)
                        observer.onCompleted()
                    } catch (let error){
                        observer.onError(APIError.parsingError)
                    }
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(APIError.forbidden)
                    case 404:
                        observer.onError(APIError.notFound)
                    case 409:
                        observer.onError(APIError.conflict)
                    case 500:
                        observer.onError(APIError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
