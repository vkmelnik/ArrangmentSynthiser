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
    var scale: MelodyScaleWithTonic = MelodyScaleWithTonic(scale: .auto, tonic: "C")

    lazy var algorithmsView = AlgorithmsView(views: [melodyView, rhythmView, chordsView], titles: ["Сгенерировать мелодию", "Сгенерировать ритм", "Сгенерировать аккорды"])
    var algorithmsViewOffConstraint: NSLayoutConstraint?
    var algorithmsViewOnConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SynthStyle.backgroundPrimary
        configureUI()
    }

    private func configureUI() {
        settingsViewController.tempoSlider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)
        settingsViewController.lengthSlider.slider.addTarget(self, action: #selector(onLengthChange), for: .valueChanged)
        configurePianoRoll()
        configureToolbar()
        configureAlgorithmsView()
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
    }

    private func configurePianoRoll() {
        self.pianoRoll = PianoRollView(pianoRollDelegate: self, length: 32, height: 120)
        let pianoRoll = SwiftUIAdapter(view: self.pianoRoll, parent: self).uiView
        view.addSubview(pianoRoll)
        pianoRoll.pinLeft(to: view)
        pianoRoll.pinRight(to: view)
        pianoRoll.pinBottom(to: view)
        pianoRoll.isUserInteractionEnabled = true
        pianoRollUIKitView = pianoRoll
    }

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
    }

    @objc
    private func onStopButton() {
        audio.stop()
        pianoRoll?.pianoRollSettings.tempo = 1
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
    }

    @objc
    private func onLengthChange(sender: UISlider, forEvent event: UIEvent) {
        pianoRoll?.pianoRollSettings.length = Int(sender.value)
    }

    @objc
    private func onAlgorithmsButton(sender: UISlider, forEvent event: UIEvent) {
        let isActive = algorithmsViewOnConstraint?.isActive ?? false
        audio.stopGeneration()
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
    private func onGenerateChordsButton(sender: UISlider, forEvent event: UIEvent) {
        loadTrack()
        audio.generateChords(scale: self.scale) { notes, error in
            self.pianoRoll?.pianoRollSettings.addedNotes = notes
        }
    }

    private func loadTrack() {
        if let selectionModel = selectionModel {
            guard let start = selectionModel.notes.min(by: { note1, note2 in
                note1.start < note2.start
            })?.start else {
                audio.loadTrack(model)
                return
            }

            guard let lastNote: PianoRollNote = selectionModel.notes.max(by: { note1, note2 in
                (note1.start + note1.length) < (note2.start + note2.length)
            }) else {
                audio.loadTrack(model)
                return
            }

            let end = lastNote.start + lastNote.length

            audio.loadTrack(PianoRollModel(notes: selectionModel.notes.map({ note in
                PianoRollNote(start: note.start - start, length: note.length, pitch: note.pitch, text: note.text, color: note.color)
            }), length: Int(end - start + 1), height: selectionModel.height))
        } else {
            audio.loadTrack(model)
        }
    }
}

extension EditorViewController: PianoRollDelegate {
    func onNotesChange(_ model: PianoRollModel) {
        self.model = model
    }

    func onSelectionMoved() {

    }

    func onSelectionDone(_ notes: [PianoRollNote]) {
        if notes.count > 0 {
            selectionModel = PianoRollModel(notes: notes, length: model.length, height: model.height)
        } else {
            selectionModel = nil
        }
    }
}
