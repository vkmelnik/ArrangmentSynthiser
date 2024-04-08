//
//  InstrumentsCoding.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import SwiftUI
import PianoRoll
import Foundation

/// Модель, описывающая представление инструментов в PianoRoll.
enum InstrumentsCoding: Int {
    case synth = 0
    case electricMandolin = 1
    case percussion = 2

    static let colors: [Color] = [
        .cyan,
        .red,
        .white
    ]

    static let defaultColor: Color = Color(red: Color.cyan.redValue, green: Color.cyan.greenValue, blue: Color.cyan.blueValue, opacity: 0.7)

    static let instruments: [InstrumentsCoding] = [
        .synth,
        .electricMandolin,
        .percussion
    ]

    static func getInstrument(_ note: PianoRollNote) -> InstrumentsCoding {
        return instruments[Int(note.text ?? "0") ?? 0]
    }

    static func getSelectedColor(_ note: PianoRollNote) -> Color {
        colors[Int(note.text ?? "0") ?? 0]
    }

    static func getColor(_ note: PianoRollNote) -> Color {
        let baseColor = colors[Int(note.text ?? "0") ?? 0]

        return Color(red: baseColor.redValue, green: baseColor.greenValue, blue: baseColor.blueValue, opacity: 0.7)
    }
}
