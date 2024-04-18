//
//  Networking.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation

typealias NetworkResult = Result<NetworkModel.Result, Error>

class Networking {
    var baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func execute(_ request: Request, completion: @escaping (NetworkResult) -> Void) {
        guard let request = convert(request) else {
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            guard let error = error else {
                completion(.success(NetworkModel.Result(data: data, response: response)))
                return
            }

            completion(.failure(error))
        }

        task.resume()
    }

    public func convert(_ request: Request) -> URLRequest? {
        guard let url = generateDestinationURL(request) else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.endpoint.headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        return urlRequest
    }

    public func generateDestinationURL(_ request: Request) -> URL? {
        guard
            let url = URL(string: baseURL),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }

        let queryItems = request.parameters
        components.path = request.endpoint.compositPath
        if let queryItems = queryItems {
            components.queryItems = convertParametersToQueryItems(queryItems)
        }

        components.encodeQueryParams()
        guard let url = components.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body

        return components.url
    }

    func convertParametersToQueryItems(_ parameters: RequestParameters) -> [URLQueryItem] {
        return parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
