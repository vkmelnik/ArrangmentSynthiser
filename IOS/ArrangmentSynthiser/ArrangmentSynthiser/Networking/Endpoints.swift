//
//  Endpoints.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 10.04.2024.
//

import Foundation

struct AlgorithmEndpoint: Endpoint {
    var compositPath: String
    var headers: HeaderModel
    var parameters: RequestParameters
}

enum AlgorithmEndpoints {
    case melody
    case rhythm
    case chords
    case drums

    func getEndpoint(headers: HeaderModel, parameters: RequestParameters) -> AlgorithmEndpoint {
        switch self {
        case .melody:
            return AlgorithmEndpoint(compositPath: "/melody", headers: headers, parameters: parameters)
        case .rhythm:
            return AlgorithmEndpoint(compositPath: "/rhythm", headers: headers, parameters: parameters)
        case .chords:
            return AlgorithmEndpoint(compositPath: "/chords", headers: headers, parameters: parameters)
        case .drums:
            return AlgorithmEndpoint(compositPath: "/drums", headers: headers, parameters: parameters)
        }
    }
}
