//
//  ElectricMandolin.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation
import AudioKit
import DevoloopAudioKit
import STKAudioKit

class ElectricMandolin: InstrumentLogic {
    let mandolin = MandolinString()
    lazy var amp = RhinoGuitarProcessor(
        mandolin,
        preGain: 5,
        postGain: 1.0,
        lowGain: 11.0,
        midGain: 0.0,
        highGain: 11.0,
        distortion: 11.0
    )

    var node: Node {
        mandolin
    }
    
    func play(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        mandolin.trigger(note: note, velocity: velocity)
    }

    func stop(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        mandolin.stop()
    }
}
