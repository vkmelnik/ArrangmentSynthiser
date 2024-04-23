//
//  AlgorithmsWorker.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 10.04.2024.
//

import Foundation

class AlgorithmsWorker {
    let networking: Networking

    init(networking: Networking = Networking(baseURL: "")) {
        self.networking = networking
    }

    func applyAlgorithm(midi: Data, endpoint: AlgorithmEndpoint, completion: @escaping (Data?, Error?) -> Void) {
        let request = Request(endpoint: endpoint, method: .post, body: midi)

        networking.execute(request) { result in
            switch result {
            case .success(let result):
                completion(result.data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
