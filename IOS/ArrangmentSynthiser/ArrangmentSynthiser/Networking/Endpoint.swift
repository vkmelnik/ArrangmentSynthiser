//
//  Endpoint.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 10.04.2024.
//

import Foundation

public enum NetworkModel {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case options = "OPTIONS"
    }

    public struct Result {
        var data: Data?
        var response: URLResponse?
    }

    public enum HTTPMethod: String {
        case GET, POST
    }

    public struct Request {
        var method: Method
        var body: Data?
        var endpoint: Endpoint
        var parameters: RequestParameters?
        var headers: [String: String]

        init(
            endpoint: Endpoint,
            method: Method = .get,
            body: Data? = nil
        ) {
            self.method = method
            self.body = body
            self.endpoint = endpoint
            self.parameters = endpoint.parameters
            self.headers = endpoint.headers
        }
    }
}

typealias HeaderModel = [String: String]
typealias RequestParameters = [(key: String, value: String)]
public typealias Request = NetworkModel.Request

protocol Endpoint {
    var compositPath: String { get }
    var headers: HeaderModel { get }
    var parameters: RequestParameters { get }
}

