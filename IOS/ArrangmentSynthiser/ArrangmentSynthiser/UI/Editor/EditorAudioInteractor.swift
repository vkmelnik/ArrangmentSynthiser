//
//  EditorAudioInteractor.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 02.04.2024.
//

import AudioKit
import DunneAudioKit
import STKAudioKit
import DevoloopAudioKit
import Foundation
import PianoRoll

class EditroAudioInteractor {
    let engine = AudioEngine()
    let instruments: [InstrumentPlayer] = [
        InstrumentPlayer(Synthiser()),
        InstrumentPlayer(ElectricMandolin()),
        InstrumentPlayer(Percussion())
    ]

    init() {
        let mixer = Mixer(instruments.map({ instrument in
            instrument.node
        }))

        mixer.volume = 1

        engine.output = mixer
        try? engine.start()
    }

    func loadTrack(_ model: PianoRollModel) {
        instruments.forEach { instrument in
            instrument.sequencer.stop()
            instrument.sequencer.setLength(Duration(beats: Double(model.length) / 4))
            instrument.sequencer.tracks.first?.clear()
            instrument.sequencer.enableLooping()
        }

        for note in model.notes {
            let instrument = instruments[InstrumentsCoding.getInstrument(note).rawValue]

            instrument.sequencer.tracks.first?.add(noteNumber: MIDINoteNumber(note.pitch), velocity: 127, position: Duration(beats: Double(note.start / 4)), duration: Duration(beats: note.length / 4))
        }

        instruments.forEach { instrument in
            instrument.sequencer.play()
        }
    }

    func setTempo(_ tempo: Double) {
        instruments.forEach { instrument in
            instrument.setTempo(tempo)
        }
    }
}
