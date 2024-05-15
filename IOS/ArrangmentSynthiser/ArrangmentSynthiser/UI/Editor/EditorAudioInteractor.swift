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

class EditorAudioInteractor {
    static let shared = EditorAudioInteractor()
    let algorithmsWorker = AlgorithmsWorker(networking: Networking(baseURL: "http://127.0.0.1:5000"))

    let engine = AudioEngine()
    let instruments: [InstrumentPlayer] = [
        InstrumentPlayer(Synthiser()),
        InstrumentPlayer(ElectricMandolin()),
        InstrumentPlayer(Drums()),
        InstrumentPlayer(Synthiser())
    ]
    lazy var masterInstrument = instruments[3]
    // Ноты, подготовленные для генерации вариаций.
    var midiForGeneration: Data?

    private init() {
        let mixer = Mixer(instruments.map({ instrument in
            instrument.node
        }))


        masterInstrument.node.bypass()
        mixer.volume = 1

        engine.output = mixer
        try? engine.start()
    }

    // MARK: - Player actions
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
            masterInstrument.sequencer.tracks.first?.add(noteNumber: MIDINoteNumber(note.pitch), velocity: 127, position: Duration(beats: Double(note.start / 4)), duration: Duration(beats: note.length / 4))
        }
    }

    func play() {
        if !engine.avEngine.isRunning {
            try? engine.start()
        }
        instruments.forEach { instrument in
            instrument.sequencer.play()
        }
    }

    func stop() {
        instruments.forEach { instrument in
            instrument.sequencer.stop()
        }
    }

    func setTempo(_ tempo: Double) {
        instruments.forEach { instrument in
            instrument.setTempo(tempo)
        }
    }

    // MARK: - Server actions
    func generateMelody(scale: MelodyScaleWithTonic, completion: @escaping ([PianoRollNote], Error?) -> Void) {
        guard let midi = getMIDI() else {
            completion([], NSErrorDomain(string: "Cannot endode MIDI") as? Error)
            return
        }

        let parameters: RequestParameters = scale.scale == .auto ? [] : [(key: "scale", value: scale.scale.rawValue), (key: "tonic", value: scale.tonic)]
        let endpoint = AlgorithmEndpoints.melody.getEndpoint(headers: ["Content-Type": "multipart/form-data"], parameters: parameters)

        algorithmsWorker.applyAlgorithm(midi: midi, endpoint: endpoint) { data, error in
            self.loadServerAnswer(data: data, error: error, completion: completion)
        }
    }

    func generateChords(scale: MelodyScaleWithTonic, completion: @escaping ([PianoRollNote], Error?) -> Void) {
        guard let midi = getMIDI() else {
            completion([], NSErrorDomain(string: "Cannot endode MIDI") as? Error)
            return
        }

        let parameters: RequestParameters = scale.scale == .auto ? [] : [(key: "scale", value: scale.scale.rawValue), (key: "tonic", value: scale.tonic)]
        let endpoint = AlgorithmEndpoints.chords.getEndpoint(headers: ["Content-Type": "multipart/form-data"], parameters: parameters)

        algorithmsWorker.applyAlgorithm(midi: midi, endpoint: endpoint) { data, error in
            self.loadServerAnswer(data: data, error: error, completion: completion)
        }
    }

    func generateRhythm(completion: @escaping ([PianoRollNote], Error?) -> Void) {
        guard let midi = getMIDI() else {
            completion([], NSErrorDomain(string: "Cannot endode MIDI") as? Error)
            return
        }

        let endpoint = AlgorithmEndpoints.rhythm.getEndpoint(headers: ["Content-Type": "multipart/form-data"], parameters: [])

        algorithmsWorker.applyAlgorithm(midi: midi, endpoint: endpoint) { data, error in
            self.loadServerAnswer(data: data, error: error, completion: completion)
        }
    }

    func generateDrums(syncopation: Float, complexity: Float, completion: @escaping ([PianoRollNote], Error?) -> Void) {
        guard let midi = getMIDI() else {
            completion([], NSErrorDomain(string: "Cannot endode MIDI") as? Error)
            return
        }

        let parameters: RequestParameters = [
            (key: "syncopation", value: syncopation.description),
            (key: "complexity", value: complexity.description)
        ]

        let endpoint = AlgorithmEndpoints.drums.getEndpoint(headers: ["Content-Type": "multipart/form-data"], parameters: parameters)

        algorithmsWorker.applyAlgorithm(midi: midi, endpoint: endpoint) { data, error in
            self.loadServerAnswer(data: data, error: error, completion: completion)
        }
    }

    func stopGeneration() {
        midiForGeneration = nil
    }

    func getMIDI() -> Data? {
        guard let midiForGeneration = midiForGeneration else {
            guard let midi = instruments[3].getMidi() else {
                return nil
            }

            self.midiForGeneration = midi
            return midi
        }

        return midiForGeneration
    }

    func loadMIDI(from url: URL, completion: @escaping ([PianoRollNote]) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            let sequencer = AppleSequencer()
            sequencer.loadMIDIFile(fromData: data)
            guard sequencer.tracks.count > 0 else {
                completion([])
                return
            }

            let notes = sequencer.tracks[0].getMIDINoteData()
            completion(notes.map({ noteData in
                PianoRollNote(start: noteData.position.beats * 4, length: noteData.duration.beats * 4, pitch: Int(noteData.noteNumber))
            }))
        } catch {
            return
        }
    }

    private func loadServerAnswer(data: Data?, error: Error?, completion: @escaping ([PianoRollNote], Error?) -> Void) {
        if let error = error {
            completion([], error)
        } else if let data = data {
            let sequencer = AppleSequencer()
            sequencer.loadMIDIFile(fromData: data)
            guard sequencer.tracks.count > 0 else {
                completion([], nil)
                return
            }

            let notes = sequencer.tracks[0].getMIDINoteData()

            completion(notes.map({ noteData in
                PianoRollNote(start: noteData.position.beats * 4, length: noteData.duration.beats * 4, pitch: Int(noteData.noteNumber))
            }), nil)

        } else {
            completion([], nil)
        }
    }
}
