//
//  Shaker.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation
import AudioKit
import STKAudioKit

class Percussion: InstrumentLogic {
    let drums = Shaker()

    var node: Node {
        drums
    }

    func play(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        drums.trigger(type: .sodaCan, amplitude: 1)
    }

    func stop(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        drums.stop()
    }
}
