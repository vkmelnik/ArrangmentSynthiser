//
//  SettingsViewController.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    var nameField = UITextField()
    var openButton = RetroUIButton.makeButton()
    var exportButton = RetroUIButton.makeButton()
    var importButton = RetroUIButton.makeButton()
    var tempoSlider = SliderView(name: "Темп: 120", value: 120, minimum: 10, maximum: 280)
    var lengthSlider = SliderView(name: "Длина трека: 16", value: 16, minimum: 16, maximum: 128)
    var doneButton = RetroUIButton.makeButton()
    var getMidi: (() -> Data?)?
    var onLoadMIDI: ((URL) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        nameField.text = StorageInteractor.shared.currentProjectName
    }

    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [nameField, openButton, exportButton, importButton, tempoSlider, lengthSlider])
        stack.axis = .vertical
        stack.spacing = 4
        view.addSubview(stack)
        stack.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 20)
        stack.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 20)
        stack.pinCenterY(to: view)
        tempoSlider.title.textColor = .white
        tempoSlider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)

        lengthSlider.title.textColor = .white
        lengthSlider.slider.addTarget(self, action: #selector(onLengthChange), for: .valueChanged)

        view.addSubview(doneButton)
        doneButton.pinTop(to: stack.bottomAnchor, 20)
        doneButton.pinCenterX(to: view)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(self, action: #selector(onDoneButton), for: .touchUpInside)

        openButton.setTitle("Открыть проект", for: .normal)
        openButton.addTarget(self, action: #selector(onOpenButton), for: .touchUpInside)

        exportButton.setTitle("Экспортировать в MIDI", for: .normal)
        exportButton.addTarget(self, action: #selector(onExportButton), for: .touchUpInside)

        importButton.setTitle("Импортировать из MIDI", for: .normal)
        importButton.addTarget(self, action: #selector(onImportButton), for: .touchUpInside)

        nameField.text = StorageInteractor.shared.currentProjectName
        nameField.addTarget(self, action: #selector(onChangeProjectName), for: .editingChanged)
        nameField.textColor = .white
    }

    @objc
    private func onTempoChange(sender: UISlider, forEvent event: UIEvent) {
        tempoSlider.title.text = "Темп: \(Int(sender.value))"
    }

    @objc
    private func onLengthChange(sender: UISlider, forEvent event: UIEvent) {
        lengthSlider.title.text = "Длина трека: \(Int(sender.value))"
    }

    @objc
    private func onDoneButton() {
        dismiss(animated: true)
    }

    @objc
    private func onOpenButton() {
        self.present(StorageViewController(), animated: true)
    }

    @objc
    private func onExportButton() {
        guard let data = getMidi?() else { return }
        guard let url = StorageInteractor.shared.saveMIDI(
            name: StorageInteractor.shared.currentProjectName, data: data
        ) else {
            return
        }

        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    @objc
    private func onImportButton() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.midi])
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = self
        present(documentPicker, animated: true)
    }

    @objc
    private func onChangeProjectName() {
        StorageInteractor.shared.currentProjectName = nameField.text ?? "Новый проект 1"
    }
}

extension SettingsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }

        onLoadMIDI?(url)
    }
}
