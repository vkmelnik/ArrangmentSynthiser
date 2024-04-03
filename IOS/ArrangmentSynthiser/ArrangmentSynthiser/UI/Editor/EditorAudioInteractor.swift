//
//  EditorAudioInteractor.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 02.04.2024.
//

import AudioKit
import DunneAudioKit
import Foundation
import PianoRoll

class EditroAudioInteractor {
    let engine = AudioEngine()
    let instrument = Synth()
    let sequencer = AppleSequencer()
    let midiCallback = MIDICallbackInstrument()

    init() {
        midiCallback.callback = { status, note, velocity in
            if status == 144 { //Note On
                self.instrument.play(noteNumber: note, velocity: velocity, channel: 0)
            } else if status == 128 { //Note Off
                self.instrument.stop(noteNumber: note, channel: 0)
            }
        }

        engine.output = instrument
        try? engine.start()
        sequencer.newTrack("Track 1")
        sequencer.setTempo(200)
        sequencer.setLength(Duration(beats: 4))
        sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
        sequencer.enableLooping()
        sequencer.tracks.first?.add(noteNumber: MIDINoteNumber(40), velocity: 127, position: Duration(beats: 0.25 * Double(0)), duration: Duration(beats: 0.25))
    }

    func loadTrack(_ model: PianoRollModel) {
        sequencer.stop()
        sequencer.setLength(Duration(beats: Double(model.length) / 2))
        sequencer.tracks.first?.clear()
        for note in model.notes {
            print(note)
            sequencer.tracks.first?.add(noteNumber: MIDINoteNumber(note.pitch), velocity: 127, position: Duration(beats: Double(note.start / 2)), duration: Duration(beats: note.length / 2))
        }
        sequencer.play()
    }

    func setTempo(_ tempo: Double) {
        sequencer.setTempo(tempo)
    }
}
