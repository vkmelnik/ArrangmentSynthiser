//
//  ViewController.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 18.01.2024.
//

import UIKit
import SwiftUI
import PianoRoll

class EditorViewController: UIViewController {
    let settingsViewController = SettingsViewController()
    let audio = EditorAudioInteractor.shared
    let recording = RecordingInteractor()
    var recordedNotes: [PianoRollNote] = []
    var algorithmNotes: [PianoRollNote]?

    // Модель всех нот.
    var model: PianoRollModel = PianoRollModel(notes: [], length: 1, height: 1)
    // Модель, содержащая только выделенные ноты.
    var selectionModel: PianoRollModel?
    var toolbar = EditorToolbarView()
    var pianoRoll: PianoRollView?
    var pianoRollUIKitView: UIView?

    let melodyView = MelodyView()
    let rhythmView = RhythmView()
    let chordsView = ChordsView()
    let drumsView = DrumsView()
    var scale: MelodyScaleWithTonic = MelodyScaleWithTonic(scale: .auto, tonic: "C")

    lazy var algorithmsView = AlgorithmsView(views: [melodyView, rhythmView, chordsView, drumsView], titles: ["Сгенерировать мелодию", "Сгенерировать ритм", "Сгенерировать аккорды", "Сгенерировать барабаны"])
    var algorithmsViewOffConstraint: NSLayoutConstraint?
    var algorithmsViewOnConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SynthStyle.backgroundPrimary
        StorageInteractor.shared.delegate = self
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        recording.askMircophonePermission()
    }

    // MARK: - Configuration
    private func configureUI() {
        settingsViewController.tempoSlider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)
        settingsViewController.lengthSlider.slider.addTarget(self, action: #selector(onLengthChange), for: .valueChanged)
        settingsViewController.getMidi = { self.loadTrack(); return self.audio.getMIDI() }
        settingsViewController.onLoadMIDI = self.load
        configurePianoRoll()
        configureToolbar()
        configureAlgorithmsView()
        configureRecording()
    }

    private func configureAlgorithmsView() {
        view.addSubview(algorithmsView)
        algorithmsView.pinTop(to: toolbar.bottomAnchor)
        algorithmsView.pinBottom(to: view)
        algorithmsViewOnConstraint = algorithmsView.pinRight(to: view)
        algorithmsViewOnConstraint?.isActive = false
        algorithmsViewOffConstraint = algorithmsView.pinLeft(to: view.trailingAnchor)
    }

    private func configureToolbar() {
        view.addSubview(toolbar)
        toolbar.pinHorizontal(to: view)
        toolbar.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        pianoRollUIKitView?.pinTop(to: toolbar.bottomAnchor, 16)
        toolbar.setHeight(70)
        view.addSubview(toolbar.instrumentsStack)
        toolbar.instrumentsStack.pinTop(to: toolbar.instrumentsButton.bottomAnchor, 8)
        toolbar.instrumentsStack.pinCenterX(to: toolbar.instrumentsButton)

        toolbar.playButton.addTarget(self, action: #selector(onPlayButton), for: .touchUpInside)
        toolbar.stopButton.addTarget(self, action: #selector(onStopButton), for: .touchUpInside)
        toolbar.selectButton.addTarget(self, action: #selector(onSelectButton), for: .touchUpInside)
        toolbar.copyButton.addTarget(self, action: #selector(onCopyButton), for: .touchUpInside)
        toolbar.pasteButton.addTarget(self, action: #selector(onPasteButton), for: .touchUpInside)
        toolbar.settingsButton.addTarget(self, action: #selector(onSettingsButton), for: .touchUpInside)
        toolbar.algorithmsButton.addTarget(self, action: #selector(onAlgorithmsButton), for: .touchUpInside)

        toolbar.synthButton.addTarget(self, action: #selector(onSynthButton), for: .touchUpInside)
        toolbar.mandolinButton.addTarget(self, action: #selector(onMandolinButton), for: .touchUpInside)
        toolbar.percussionButton.addTarget(self, action: #selector(onPercussionButton), for: .touchUpInside)

        melodyView.generateButton.addTarget(self, action: #selector(onGenerateMelodyButton), for: .touchUpInside)
        melodyView.onScaleChange = { scale in
            self.scale = MelodyScaleWithTonic(scale: scale, tonic: self.scale.tonic)
        }
        melodyView.onTonicChange = { tonic in
            self.scale = MelodyScaleWithTonic(scale: self.scale.scale, tonic: tonic)
        }

        chordsView.generateButton.addTarget(self, action: #selector(onGenerateChordsButton), for: .touchUpInside)
        chordsView.onScaleChange = { scale in
            self.scale = MelodyScaleWithTonic(scale: scale, tonic: self.scale.tonic)
        }
        chordsView.onTonicChange = { tonic in
            self.scale = MelodyScaleWithTonic(scale: self.scale.scale, tonic: tonic)
        }

        rhythmView.generateButton.addTarget(self, action: #selector(onGenerateRhythmButton), for: .touchUpInside)
        drumsView.generateButton.addTarget(self, action: #selector(onGenerateDrumsButton), for: .touchUpInside)
    }

    private func configureRecording() {
        toolbar.recordButton.addTarget(self, action: #selector(onRecordButton), for: .touchUpInside)
        recording.delegate = self
    }

    private func configurePianoRoll() {
        self.pianoRoll = PianoRollView(pianoRollDelegate: self, length: 16, height: 120)
        let pianoRoll = SwiftUIAdapter(view: self.pianoRoll, parent: self).uiView
        view.addSubview(pianoRoll)
        pianoRoll.pinLeft(to: view)
        pianoRoll.pinRight(to: view)
        pianoRoll.pinBottom(to: view)
        pianoRoll.isUserInteractionEnabled = true
        pianoRollUIKitView = pianoRoll
    }

    // MARK: - Buttons actions.
    @objc
    private func onSettingsButton() {
        present(settingsViewController, animated: true)
    }

    @objc
    private func onPlayButton() {
        loadTrack()
        audio.play()
        if selectionModel == nil {
            pianoRoll?.pianoRollSettings.tempo = settingsViewController.tempoSlider.slider.value
        }

        save()
    }

    @objc
    private func onStopButton() {
        audio.stop()
        pianoRoll?.pianoRollSettings.tempo = 1
    }

    @objc
    private func onRecordButton() {
        if recording.active {
            recording.stop()
            toolbar.recordButton.backgroundColor = .darkGray
            pianoRoll?.pianoRollSettings.addedNotes = recordedNotes
        } else {
            recordedNotes = []
            recording.start()
            toolbar.recordButton.backgroundColor = .red
        }
    }

    @objc
    private func onSelectButton() {
        if let scrollViewOn = pianoRoll?.pianoRollSettings.scrollViewOn {
            pianoRoll?.pianoRollSettings.currentInstrument = nil
            pianoRoll?.pianoRollSettings.scrollViewOn = !scrollViewOn
            toolbar.selectButton.setTitle(scrollViewOn ? "Подвинуть" : "Выделить", for: .normal)
        }
    }

    @objc
    private func onCopyButton() {
        pianoRoll?.pianoRollSettings.copy = !(pianoRoll?.pianoRollSettings.paste ?? false)
        showCopyPaste(false)
    }

    @objc
    private func onPasteButton() {
        pianoRoll?.pianoRollSettings.paste = !(pianoRoll?.pianoRollSettings.paste ?? false)
        showCopyPaste(false)
    }

    @objc
    private func onSynthButton() {
        pianoRoll?.pianoRollSettings.currentInstrument = 0
        pianoRoll?.pianoRollSettings.scrollViewOn = false
    }

    @objc
    private func onMandolinButton() {
        pianoRoll?.pianoRollSettings.currentInstrument = 1
        pianoRoll?.pianoRollSettings.scrollViewOn = false
    }

    @objc
    private func onPercussionButton() {
        pianoRoll?.pianoRollSettings.currentInstrument = 2
        pianoRoll?.pianoRollSettings.scrollViewOn = false
    }

    @objc
    private func onTempoChange(sender: UISlider, forEvent event: UIEvent) {
        audio.setTempo(Double(Int(sender.value)))
        if pianoRoll?.pianoRollSettings.tempo ?? 0 > 2 {
            pianoRoll?.pianoRollSettings.tempo = sender.value
        }
        recording.tempo = Double(Int(sender.value))
    }

    @objc
    private func onLengthChange(sender: UISlider, forEvent event: UIEvent) {
        pianoRoll?.pianoRollSettings.length = Int(sender.value)
    }

    @objc
    private func onAlgorithmsButton(sender: UISlider, forEvent event: UIEvent) {
        let isActive = algorithmsViewOnConstraint?.isActive ?? false
        audio.stopGeneration()
        algorithmNotes = nil
        algorithmsViewOnConstraint?.isActive = !isActive
        algorithmsViewOffConstraint?.isActive = isActive
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @objc
    private func onGenerateMelodyButton(sender: UISlider, forEvent event: UIEvent) {
        loadTrack()
        audio.generateMelody(scale: self.scale) { notes, error in
            self.pianoRoll?.pianoRollSettings.addedNotes = notes
        }
    }

    @objc
    private func onGenerateRhythmButton(sender: UISlider, forEvent event: UIEvent) {
        loadTrack()
        audio.generateRhythm { notes, error in
            self.pianoRoll?.pianoRollSettings.addedNotes = notes
        }
    }

    @objc
    private func onGenerateDrumsButton(sender: UISlider, forEvent event: UIEvent) {
        var initialNotes: [PianoRollNote]
        if let notes = algorithmNotes {
            initialNotes = notes
        } else {
            initialNotes = loadTrack()
            algorithmNotes = initialNotes
        }

        let syncopation = drumsView.syncopationSlider.slider.value
        let complexity = drumsView.complexitySlider.slider.value
        audio.generateDrums(syncopation: syncopation, complexity: complexity) { notes, error in
            self.pianoRoll?.pianoRollSettings.addedNotes = initialNotes + notes.map({ note in
                PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, text: String(InstrumentsCoding.percussion.rawValue), color: InstrumentsCoding.colors[InstrumentsCoding.percussion.rawValue])
            })
        }
    }

    @objc
    private func onGenerateChordsButton(sender: UISlider, forEvent event: UIEvent) {
        loadTrack()
        audio.generateChords(scale: self.scale) { notes, error in
            self.pianoRoll?.pianoRollSettings.addedNotes = notes
        }
    }

    // MARK: - Private methods.
    @discardableResult
    private func loadTrack() -> [PianoRollNote] {
        if let selectionModel = selectionModel {
            guard let start = selectionModel.notes.min(by: { note1, note2 in
                note1.start < note2.start
            })?.start else {
                audio.loadTrack(model)
                return model.notes
            }

            guard let lastNote: PianoRollNote = selectionModel.notes.max(by: { note1, note2 in
                (note1.start + note1.length) < (note2.start + note2.length)
            }) else {
                audio.loadTrack(model)
                return model.notes
            }

            let end = lastNote.start + lastNote.length

            let selected = PianoRollModel(notes: selectionModel.notes.map({ note in
                PianoRollNote(start: note.start - start, length: note.length, pitch: note.pitch, text: note.text, color: note.color)
            }), length: Int(end - start + 1), height: selectionModel.height)
            audio.loadTrack(selected)

            return selected.notes
        } else {
            audio.loadTrack(model)
            return model.notes
        }
    }

    private func save() {
        StorageInteractor.shared.save(
            name: StorageInteractor.shared.currentProjectName,
            notes: model.notes,
            length: Double(pianoRoll?.pianoRollSettings.length ?? 16),
            tempo: Double(pianoRoll?.pianoRollSettings.tempo ?? 120)
        )
    }
}
