//
//  Editor+PianoRollDelegate.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.05.2024.
//

import PianoRoll

extension EditorViewController: PianoRollDelegate {
    func onNotesChange(_ model: PianoRollModel) {
        self.model = model
    }

    func onSelectionMoved() {

    }

    func onSelectionDone(_ notes: [PianoRollNote]) {
        if notes.count > 0 {
            selectionModel = PianoRollModel(notes: notes, length: model.length, height: model.height)
        } else {
            selectionModel = nil
        }
    }

    func showCopyPaste(_ value: Bool) {
        toolbar.pasteButton.isHidden = !value
        toolbar.copyButton.isHidden = !value
    }
}
