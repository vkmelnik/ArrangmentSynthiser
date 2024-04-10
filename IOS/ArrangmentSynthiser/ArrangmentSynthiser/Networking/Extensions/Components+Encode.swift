//
//  Components+Encode.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 10.04.2024.
//

import Foundation

extension URLComponents {
    // MARK: - Functions
    mutating func removeQueryParam(with name: String) {
        queryItems = queryItems?.filter({ $0.name != name })
        encodeQueryParams()
    }

    mutating func encodeQueryParams() {
        guard let queryItems = queryItems, !queryItems.isEmpty else {
            return
        }

        let items = queryItems.map({URLQueryItem(
            name: $0.name,
            value: $0.value?.addingPercentEncoding(withAllowedCharacters: .alphanumerics))
        })
        percentEncodedQueryItems = items
    }
}
