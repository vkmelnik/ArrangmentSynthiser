//
//  SettingsViewController.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    var slider = SliderView(name: "Темп: 120", value: 120, minimum: 10, maximum: 280)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        configureUI()
    }

    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [slider])
        stack.alignment = .center
        view.addSubview(stack)
        stack.pinHorizontal(to: view, 20)
        stack.pinVertical(to: view)
        slider.title.textColor = .white
        slider.slider.addTarget(self, action: #selector(onTempoChange), for: .valueChanged)
    }

    @objc
    private func onTempoChange(sender: UISlider, forEvent event: UIEvent) {
        slider.title.text = "Темп: \(Int(sender.value))"
    }
}
