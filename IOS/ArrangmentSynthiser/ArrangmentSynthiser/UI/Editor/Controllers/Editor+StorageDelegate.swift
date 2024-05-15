//
//  Editor+StorageDelegate.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.05.2024.
//

import PianoRoll
import Foundation

extension EditorViewController: StorageDelegate {
    func load(_ project: ProjectModel) {
        audio.setTempo(project.tempo)
        if pianoRoll?.pianoRollSettings.tempo ?? 0 > 2 {
            pianoRoll?.pianoRollSettings.tempo = Float(project.tempo)
        }
        recording.tempo = project.tempo

        pianoRoll?.pianoRollSettings.length = Int(project.length)
        StorageInteractor.shared.currentProjectName = project.name

        pianoRoll?.pianoRollSettings.addedNotes = project.notes.map({ note in
            var note = PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, text: note.text)
            note.color = InstrumentsCoding.getColor(note)

            return note
        })
    }

    func load(_ midi: URL) {
        audio.loadMIDI(from: midi) { notes in
            self.pianoRoll?.pianoRollSettings.addedNotes = notes
        }
    }
}
