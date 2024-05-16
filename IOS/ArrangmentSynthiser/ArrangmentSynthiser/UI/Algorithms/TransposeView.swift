//
//  TransposeView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 17.05.2024.
//

import Foundation
import UIKit

class TransposeView: AlgorithmView {
    let scales: [MelodyScale] = [.auto, .major, .minor]
    let scaleNames: [String] = ["Авто", "Мажор", "Минор"]
    let notes: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    var fromScalePickerView = NamedPickerView(name: "Начальный лад")
    var fromTonicPickerView = NamedPickerView(name: "Тоника")
    var toScalePickerView = NamedPickerView(name: "Конечный лад")
    var toTonicPickerView = NamedPickerView(name: "Тоника")
    var onScaleChange: ((MelodyScale) -> Void)? = nil
    var onTonicChange: ((String) -> Void)? = nil
    var onToScaleChange: ((MelodyScale) -> Void)? = nil
    var onToTonicChange: ((String) -> Void)? = nil

    override init() {
        super.init()
        fromScalePickerView.pickerView.tag = 0
        fromScalePickerView.pickerView.dataSource = self
        fromScalePickerView.pickerView.delegate = self
        stack.addArrangedSubview(fromScalePickerView)
        fromTonicPickerView.pickerView.tag = 1
        fromTonicPickerView.pickerView.dataSource = self
        fromTonicPickerView.pickerView.delegate = self
        stack.addArrangedSubview(fromTonicPickerView)

        toScalePickerView.pickerView.tag = 2
        toScalePickerView.pickerView.dataSource = self
        toScalePickerView.pickerView.delegate = self
        stack.addArrangedSubview(toScalePickerView)
        toTonicPickerView.pickerView.tag = 3
        toTonicPickerView.pickerView.dataSource = self
        toTonicPickerView.pickerView.delegate = self
        stack.addArrangedSubview(toTonicPickerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransposeView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag % 2 == 0 {
            return scales.count
        } else {
            return notes.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag % 2 == 0 {
            return NSAttributedString(string: scaleNames[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else {
            return NSAttributedString(string: notes[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            onScaleChange?(scales[row])
        case 1:
            onTonicChange?(notes[row])
        case 2:
            onToScaleChange?(scales[row])
        case 3:
            onToTonicChange?(notes[row])
        default:
            break
        }
    }
}
