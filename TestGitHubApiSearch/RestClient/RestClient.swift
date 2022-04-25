//
//  RestClient.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RxSwift

public enum RestClientError: Error {
    case jsonParse(className: String)
    case requestError
    case network(statusCode: Int)
    case unknown(Error?)

    var description: String {
        switch self{
        case let .unknown(error):
            return error?.localizedDescription ?? "Generic error message"
        case let .jsonParse(className):
            return "An Error ocurred while parsing Json for class: \(className)"
        case let .network(statusCode):
            return "Network error with Http status code: \(statusCode)"
        case .requestError:
            return "Request could not be created"
        }
    }
}

public protocol RestClient {
    func execute<T: Decodable>(
        request: URLRequest?,
        with model: T.Type
    ) -> Single<T?>
}

public class RestClientImpl: RestClient {
    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func execute<T: Decodable>(
        request: URLRequest?,
        with model: T.Type
    ) -> Single<T?> {
        guard let request = request else {
            return .error(RestClientError.requestError)
        }

        return Single.create { observer in
            URLSession.shared
                .dataTask(with: request) { [unowned self] data, response, error in
                    if let error = error {
                        observer(.failure(RestClientError.unknown(error)))
                    }

                    guard let httpUrlResponse = response as? HTTPURLResponse else {
                        observer(.failure(RestClientError.unknown(error)))
                        return
                    }

                    switch httpUrlResponse.statusCode {
                    case 200...299:
                        guard let data = data else {
                            /// in case there's no response body (like http 204) return success without model
                            /// in a real app map to Completable instead of Single
                            observer(.success(nil))
                            return
                        }

                        do {
                            let model = try decoder.decode(T.self, from: data)
                            observer(.success(model))
                        } catch {
                            return observer(.failure(RestClientError.jsonParse(className: String(describing: T.self))))
                        }
                    default:
                        /// for the sake of simplicity in this project, I'm just going to assume all codes between 200 and 299 are success and the rest are some kind of error
                        observer(.failure(
                            RestClientError.network(statusCode: httpUrlResponse.statusCode))
                        )
                    }
                }
                .resume()

            return Disposables.create()
        }
    }
}
