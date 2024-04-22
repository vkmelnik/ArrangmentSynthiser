//
//  MelodyView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 10.04.2024.
//

import UIKit

enum MelodyScale: String {
    case auto = "Auto"
    case minor = "Minor"
    case major = "Major"
}

struct MelodyScaleWithTonic {
    let scale: MelodyScale
    let tonic: String
}

class MelodyView: AlgorithmView {
    let scales: [MelodyScale] = [.auto, .major, .minor]
    let scaleNames: [String] = ["Авто", "Мажор", "Минор"]
    let notes: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    var scalePickerView = UIPickerView()
    var tonicPickerView = UIPickerView()
    var onScaleChange: ((MelodyScale) -> Void)? = nil
    var onTonicChange: ((String) -> Void)? = nil

    override init() {
        super.init()
        scalePickerView.tag = 0
        scalePickerView.dataSource = self
        scalePickerView.delegate = self
        stack.addArrangedSubview(scalePickerView)
        tonicPickerView.tag = 1
        tonicPickerView.dataSource = self
        tonicPickerView.delegate = self
        stack.addArrangedSubview(tonicPickerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MelodyView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return scales.count
        } else {
            return notes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 0 {
            return NSAttributedString(string: scaleNames[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            return NSAttributedString(string: notes[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            onScaleChange?(scales[row])
        } else {
            onTonicChange?(notes[row])
        }
    }
}
