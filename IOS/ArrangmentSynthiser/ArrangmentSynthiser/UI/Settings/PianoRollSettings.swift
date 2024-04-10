//
//  PianoRollSettings.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import Foundation
import PianoRoll

class PianoRollSettings: ObservableObject {
    @Published var length: Int = 32
    @Published var scrollViewOn: Bool = true
    @Published var currentInstrument: Int? = nil
    @Published var addedNotes: [PianoRollNote] = []
}
