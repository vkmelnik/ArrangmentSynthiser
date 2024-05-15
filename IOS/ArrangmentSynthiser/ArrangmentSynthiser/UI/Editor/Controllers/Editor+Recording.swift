//
//  Editor+Recording.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.05.2024.
//

import PianoRoll

extension EditorViewController: RecordingDelegate {
    func onNote(_ note: PianoRollNote) {
        recordedNotes.append(note)
    }
}
