//
//  Instrument.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation
import AudioKit
import DunneAudioKit
import STKAudioKit
import DevoloopAudioKit

class InstrumentPlayer {
    let instrument: InstrumentLogic
    let sequencer = AppleSequencer()
    let midiCallback = MIDICallbackInstrument()

    var node: Node {
        instrument.node
    }

    init(_ instrument: InstrumentLogic) {
        self.instrument = instrument

        midiCallback.callback = { status, note, velocity in
            if status == 144 { // Note On
                self.instrument.play(note: note, velocity: velocity)
            } else if status == 128 { // Note Off
                self.instrument.stop(note: note, velocity: velocity)
            }
        }

        sequencer.newTrack("Track 1")
        sequencer.setTempo(200)
        sequencer.setLength(Duration(beats: 4))
        sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
        sequencer.enableLooping()
    }

    func setTempo(_ tempo: Double) {
        sequencer.setTempo(tempo)
    }

    func getMidi() -> Data? {
        let midiData = sequencer.genData()
        let duration = sequencer.length
        do {
            let documentUrl = FileManager.default.temporaryDirectory
            let recordUrl = documentUrl.appendingPathComponent("Test.mid")
            try midiData?.write(to: recordUrl)
        } catch {
            print("Ошибка сохранения записи: \(error.localizedDescription)")
        }

        return midiData
    }
}
