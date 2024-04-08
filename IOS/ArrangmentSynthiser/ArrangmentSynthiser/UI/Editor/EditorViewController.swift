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
    let audio = EditroAudioInteractor()
    var model: PianoRollModel = PianoRollModel(notes: [], length: 1, height: 1)
    var selectionModel: PianoRollModel? = nil
    var toolbar = EditorToolbarView()
    var pianoRoll: PianoRollView? = nil

    var algorithmsView = AlgorithmsView(views: [AlgorithmView()], titles: ["Сгенерировать мелодию"])
    var algorithmsViewOffConstraint: NSLayoutConstraint?
    var algorithmsViewOnConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        configureUI()
    }

    private func configureUI() {
        settingsViewController.tempoSlider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)
        settingsViewController.lengthSlider.slider.addTarget(self, action: #selector(onLengthChange), for: .valueChanged)
        configureToolbar()
        configurePianoRoll()
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
        toolbar.setHeight(70)

        toolbar.playButton.addTarget(self, action: #selector(onPlayButton), for: .touchUpInside)
        toolbar.selectButton.addTarget(self, action: #selector(onSelectButton), for: .touchUpInside)
        toolbar.settingsButton.addTarget(self, action: #selector(onSettingsButton), for: .touchUpInside)
        toolbar.algorithmsButton.addTarget(self, action: #selector(onAlgorithmsButton), for: .touchUpInside)

        toolbar.synthButton.addTarget(self, action: #selector(onSynthButton), for: .touchUpInside)
        toolbar.mandolinButton.addTarget(self, action: #selector(onMandolinButton), for: .touchUpInside)
        toolbar.percussionButton.addTarget(self, action: #selector(onPercussionButton), for: .touchUpInside)
    }

    private func configurePianoRoll() {
        self.pianoRoll = PianoRollView(pianoRollDelegate: self, length: 32, height: 120)
        let pianoRoll = SwiftUIAdapter(view: self.pianoRoll, parent: self).uiView
        view.addSubview(pianoRoll)
        pianoRoll.pinLeft(to: view)
        pianoRoll.pinRight(to: view)
        pianoRoll.pinBottom(to: view)
        pianoRoll.pinTop(to: toolbar.bottomAnchor, 16)
        pianoRoll.isUserInteractionEnabled = true
    }

    @objc
    private func onSettingsButton() {
        present(settingsViewController, animated: true)
    }

    @objc
    private func onPlayButton() {
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

    @objc
    private func onSelectButton() {
        if let scrollViewOn = pianoRoll?.pianoRollSettings.scrollViewOn {
            pianoRoll?.pianoRollSettings.currentInstrument = 0
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
    }

    @objc
    private func onLengthChange(sender: UISlider, forEvent event: UIEvent) {
        pianoRoll?.pianoRollSettings.length = Int(sender.value)
    }

    @objc
    private func onAlgorithmsButton(sender: UISlider, forEvent event: UIEvent) {
        let isActive = algorithmsViewOnConstraint?.isActive ?? false
        algorithmsViewOnConstraint?.isActive = !isActive
        algorithmsViewOffConstraint?.isActive = isActive
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
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
