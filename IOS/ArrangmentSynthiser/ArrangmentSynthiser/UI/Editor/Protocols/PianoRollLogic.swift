//
//  PianoRollLogic.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 02.04.2024.
//

import PianoRoll

protocol PianoRollDelegate: AnyObject {
    func onNotesChange(_ model: PianoRollModel)
    func onSelectionMoved()
    func onSelectionDone(_ notes: [PianoRollNote])
    func showCopyPaste(_ value: Bool)
}
