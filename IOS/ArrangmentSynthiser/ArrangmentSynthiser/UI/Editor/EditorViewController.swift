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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        configureUI()
    }

    private func configureUI() {
        settingsViewController.slider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)
        configureToolbar()
        configurePianoRoll()
    }

    private func configureToolbar() {
        view.addSubview(toolbar)
        toolbar.pinHorizontal(to: view)
        toolbar.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        toolbar.setHeight(70)

        toolbar.playButton.addTarget(self, action: #selector(onPlayButton), for: .touchUpInside)
        toolbar.selectButton.addTarget(self, action: #selector(onSelectButton), for: .touchUpInside)
        toolbar.settingsButton.addTarget(self, action: #selector(onSettingsButton), for: .touchUpInside)
    }

    private func configurePianoRoll() {
        self.pianoRoll = PianoRollView(pianoRollDelegate: self, length: 32, height: 120)
        let pianoRoll = SwiftUIAdapter(view: self.pianoRoll, parent: self).uiView
        view.addSubview(pianoRoll)
        pianoRoll.pinLeft(to: view)
        pianoRoll.pinRight(to: view)
        pianoRoll.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        pianoRoll.pinTop(to: toolbar.bottomAnchor, 16)
        pianoRoll.isUserInteractionEnabled = true
    }

    @objc
    private func onSettingsButton() {
        present(settingsViewController, animated: true)
    }

    @objc
    private func onPlayButton() {
        if var selectionModel = selectionModel {
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
                PianoRollNote(start: note.start - start, length: note.length, pitch: note.pitch)
            }), length: Int(end - start + 1), height: selectionModel.height))
        } else {
            audio.loadTrack(model)
        }
    }

    @objc
    private func onSelectButton() {
        if let scrollViewOn = pianoRoll?.pianoRollSettings.scrollViewOn {
            pianoRoll?.pianoRollSettings.scrollViewOn = !scrollViewOn
            toolbar.selectButton.setTitle(scrollViewOn ? "Подвинуть" : "Выделить", for: .normal)
        }
    }

    @objc
    private func onTempoChange(sender: UISlider, forEvent event: UIEvent) {
        audio.setTempo(Double(Int(sender.value)))
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
