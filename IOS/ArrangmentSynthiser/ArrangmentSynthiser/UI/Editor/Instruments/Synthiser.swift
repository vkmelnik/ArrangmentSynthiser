//
//  Synthiser.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation
import AudioKit
import DunneAudioKit

class Synthiser: InstrumentLogic {
    let synth = Synth()

    var node: Node {
        synth
    }

    func play(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        synth.play(noteNumber: note, velocity: velocity)
    }

    func stop(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        synth.stop(noteNumber: note)
    }
}
