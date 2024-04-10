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
    let algorithmsWorker = AlgorithmsWorker(networking: Networking(baseURL: "http://127.0.0.1:8080"))

    let engine = AudioEngine()
    let instruments: [InstrumentPlayer] = [
        InstrumentPlayer(Synthiser()),
        InstrumentPlayer(ElectricMandolin()),
        InstrumentPlayer(Percussion())
    ]
    let masterInstrument = InstrumentPlayer(Synthiser())

    init() {
        let mixer = Mixer(instruments.map({ instrument in
            instrument.node
        }))

        mixer.addInput(masterInstrument.node)
        mixer.volume = 1

        engine.output = mixer
        try? engine.start()
    }

    func loadTrack(_ model: PianoRollModel) {
        masterInstrument.sequencer.tracks.first?.clear()
        masterInstrument.sequencer.setLength(Duration(beats: Double(model.length) / 4))

        instruments.forEach { instrument in
            instrument.sequencer.stop()
            instrument.sequencer.setLength(Duration(beats: Double(model.length) / 4))
            instrument.sequencer.tracks.first?.clear()
            instrument.sequencer.enableLooping()
        }

        for note in model.notes {
            masterInstrument.sequencer.tracks.first?.add(noteNumber: MIDINoteNumber(note.pitch), velocity: 127, position: Duration(beats: Double(note.start / 4)), duration: Duration(beats: note.length / 4))

            let instrument = instruments[InstrumentsCoding.getInstrument(note).rawValue]

            instrument.sequencer.tracks.first?.add(noteNumber: MIDINoteNumber(note.pitch), velocity: 127, position: Duration(beats: Double(note.start / 4)), duration: Duration(beats: note.length / 4))
        }
    }

    func play() {
        instruments.forEach { instrument in
            instrument.sequencer.play()
        }
    }

    func setTempo(_ tempo: Double) {
        masterInstrument.setTempo(tempo)
        instruments.forEach { instrument in
            instrument.setTempo(tempo)
        }
    }

    func generateMelody(completion: @escaping ([PianoRollNote], Error?) -> Void) {
        guard let midi = masterInstrument.getMidi() else {
            completion([], NSErrorDomain(string: "Cannot endode MIDI") as? Error)
            return
        }

        let endpoint = AlgorithmEndpoints.melody.getEndpoint(headers: [:], parameters: [])

        algorithmsWorker.applyAlgorithm(midi: midi, endpoint: endpoint) { data, error in
            if let error = error {
                completion([], error)
            } else if let data = data {
                self.masterInstrument.sequencer.loadMIDIFile(fromData: data)
                guard self.masterInstrument.sequencer.tracks.count > 0 else {
                    completion([], nil)
                    return
                }

                let notes = self.masterInstrument.sequencer.tracks[0].getMIDINoteData()

                completion(notes.map({ noteData in
                    PianoRollNote(start: noteData.position.beats * 4, length: noteData.duration.beats * 4, pitch: Int(noteData.noteNumber))
                }), nil)
            } else {
                completion([], nil)
            }
        }
    }
}
