//
//  ProjectModel.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 28.04.2024.
//

import Foundation
import PianoRoll
import SwiftUI

struct ProjectModel: Codable {
    struct StorageNote: Codable {
        let start: Double
        let length: Double
        let pitch: Int
        let text: String?
    }

    let name: String
    let length: Double
    let tempo: Double
    let notes: [StorageNote]
}
