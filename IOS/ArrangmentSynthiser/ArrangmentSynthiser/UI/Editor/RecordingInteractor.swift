//
//  RecordingController.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 27.04.2024.
//

import Beethoven
import AVFAudio
import PianoRoll

class RecordingInteractor {
    private struct Constants {
        static let levelThreshold: Float = -30
        static let estimationStrategy: EstimationStrategy = .yin
    }

    private let letters: [Beethoven.Note.Letter] = [
      .C,
      .CSharp,
      .D,
      .DSharp,
      .E,
      .F,
      .FSharp,
      .G,
      .GSharp,
      .A,
      .ASharp,
      .B
    ]

    private var currentPitch: Int?
    private var currentPitchStart: Date?
    private var recordingStart: Date?
    var delegate: RecordingDelegate?
    var tempo: Double = 120
    private(set) var active: Bool = false

    lazy var pitchEngine: PitchEngine = {
        let config = Config(bufferSize: 4096, estimationStrategy: Constants.estimationStrategy)
        let pitchEngine = PitchEngine(config: config, delegate: self)
        pitchEngine.levelThreshold = Constants.levelThreshold
        return pitchEngine
    }()

    func askMircophonePermission() {
        if AVAudioSession.sharedInstance().recordPermission != .granted {
            AVAudioSession.sharedInstance().requestRecordPermission { permission in
                print("Доступ к микрофону: \(permission)")
            }
        }
    }

    func start() {
        guard AVAudioSession.sharedInstance().recordPermission == .granted else {
            print("Ошибка доступа к микрофону")
            return
        }

        recordingStart = Date()
        currentPitch = nil
        currentPitchStart = nil
        pitchEngine.start()
        active = true
    }

    func stop() {
        guard AVAudioSession.sharedInstance().recordPermission == .granted else {
            print("Ошибка доступа к микрофону")
            return
        }

        pitchEngine.stop()
        active = false
    }
}

extension RecordingInteractor: PitchEngineDelegate {
    func pitchEngine(_ pitchEngine: Beethoven.PitchEngine, didReceivePitch pitch: Beethoven.Pitch) {
        if let currentPitch = currentPitch, let currentPitchStart = currentPitchStart,
           currentPitch != getPianoRollPitch(pitch) {
            addNote(currentPitch, start: currentPitchStart, end: Date())
            self.currentPitch = getPianoRollPitch(pitch)
            self.currentPitchStart = Date()
        } else if currentPitch == nil {
            self.currentPitch = getPianoRollPitch(pitch)
            self.currentPitchStart = Date()
        }
    }

    func pitchEngineWentBelowLevelThreshold(_ pitchEngine: Beethoven.PitchEngine) {
        if let currentPitch = currentPitch, let currentPitchStart = currentPitchStart {
            addNote(currentPitch, start: currentPitchStart, end: Date())
        }
    }

    private func addNote(_ pitch: Int, start: Date, end: Date) {
        guard let trackStart = self.recordingStart else { return }
        let duration: Double = end.timeIntervalSince(start) * tempo / 60 * 4
        let startPosition: Double = start.timeIntervalSince(trackStart) * tempo / 60 * 4
        delegate?.onNote(PianoRollNote(start: startPosition, length: duration, pitch: pitch))
        self.currentPitch = nil
        self.currentPitchStart = nil
    }

    private func getPianoRollPitch(_ pitch: Beethoven.Pitch) -> Int {
        let count = letters.count
        let letterIndex = letters.firstIndex(of: pitch.note.letter) ?? 0

        return letterIndex + count * (pitch.note.octave - (-1)) + 1
    }

    func pitchEngine(_ pitchEngine: Beethoven.PitchEngine, didReceiveError error: Error) {
        print(error)
    }
}
