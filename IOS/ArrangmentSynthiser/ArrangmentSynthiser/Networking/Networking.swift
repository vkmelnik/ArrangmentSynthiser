//
//  Networking.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation

class Networking {
    var baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func applyAlgorithm(algorithm: String, midiURL: String, settings: [String: String], completion: (Data?, URLResponse, Error?)) {
        let session = URLSession.shared
        //let task = session.dataTask(with: <#T##URLRequest#>, completionHandler: completion)


        //task.resume()
    }
}
