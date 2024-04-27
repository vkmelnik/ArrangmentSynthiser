//
//  RecordingLogic.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 27.04.2024.
//

import PianoRoll

protocol RecordingDelegate {
    func onNote(_ note: PianoRollNote)
}
