//
//  Drums.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 14.05.2024.
//

import AudioKit
import Foundation
import AVFAudio

class Drums: InstrumentLogic {
    let kick = AppleSampler()
    let snare = AppleSampler()
    let openHat = AppleSampler()
    let closedHat = AppleSampler()
    let crash = AppleSampler()
    let ride = AppleSampler()
    lazy var mixer = Mixer([kick, snare, openHat, closedHat, crash, ride])
    lazy var drums = [35: kick, 38: snare, 46: openHat, 44: closedHat, 49: crash, 51: ride]

    var node: Node {
        mixer
    }

    init() {
        do {
            let drums: [AppleSampler] = [kick, snare, openHat, closedHat, crash, ride]
            let files = ["kick", "snare", "openhat", "closedhat", "crash", "ride"]
            for i in 0..<drums.count {
                if let file = loadSample(file: files[i]) {
                    try drums[i].loadAudioFile(file)
                } else {
                    print("Unable to load sample for \(files[i])")
                }
            }
        } catch {
            Log("Could not load audio files \(error)")
        }
    }

    func play(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        drums[Int(note)]?.play(noteNumber: 60, velocity: velocity)
    }

    func stop(note: AudioKit.MIDIByte, velocity: AudioKit.MIDIByte) {
        // drums[Int(note)]?.stop(noteNumber: note)
    }

    private func loadSample(file: String) -> AVAudioFile? {
        guard let url = Bundle.main.url(forResource: file, withExtension: "wav") else {
            print("Could not find: \(file)")
            return nil
        }

        do {
            return try AVAudioFile(forReading: url)
        } catch {
            print("Could not load: \(url)")
            return nil
        }
    }
}
