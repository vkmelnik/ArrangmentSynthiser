//
//  SettingsViewController.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    var tempoSlider = SliderView(name: "Темп: 120", value: 120, minimum: 10, maximum: 280)
    var lengthSlider = SliderView(name: "Длина трека: 120", value: 32, minimum: 16, maximum: 128)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        configureUI()
    }

    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [tempoSlider, lengthSlider])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.pinHorizontal(to: view, 20)
        stack.pinCenterY(to: view)
        tempoSlider.title.textColor = .white
        tempoSlider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)

        lengthSlider.title.textColor = .white
        lengthSlider.slider.addTarget(self, action: #selector(onLengthChange), for: .valueChanged)
    }

    @objc
    private func onTempoChange(sender: UISlider, forEvent event: UIEvent) {
        tempoSlider.title.text = "Темп: \(Int(sender.value))"
    }

    @objc
    private func onLengthChange(sender: UISlider, forEvent event: UIEvent) {
        lengthSlider.title.text = "Длина трека: \(Int(sender.value))"
    }
}
