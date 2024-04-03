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
    let audio = EditroAudioInteractor()
    var model: PianoRollModel = PianoRollModel(notes: [], length: 1, height: 1)
    var toolbar = EditorToolbarView()
    var pianoRoll: PianoRollView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        configureUI()
    }

    private func configureUI() {
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
    }

    private func configurePianoRoll() {
        self.pianoRoll = PianoRollView(pianoRollDelegate: self, length: 8, height: 120)
        let pianoRoll = SwiftUIAdapter(view: self.pianoRoll, parent: self).uiView
        view.addSubview(pianoRoll)
        pianoRoll.pinLeft(to: view, 200)
        pianoRoll.pinRight(to: view)
        pianoRoll.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        pianoRoll.pinTop(to: toolbar.bottomAnchor, 16)
        pianoRoll.isUserInteractionEnabled = true
    }

    @objc
    private func onPlayButton() {
        audio.loadTrack(model)
    }

    @objc
    private func onSelectButton() {
        if let scrollViewOn = pianoRoll?.pianoRollSettings.scrollViewOn {
            pianoRoll?.pianoRollSettings.scrollViewOn = !scrollViewOn
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
        print(notes)
    }
}
