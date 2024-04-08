//
//  InstrumentProtocol.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import Foundation
import AudioKit

protocol InstrumentLogic {
    var node: Node { get }
    func play(note: MIDIByte, velocity: MIDIByte) -> Void
    func stop(note: MIDIByte, velocity: MIDIByte) -> Void
}
