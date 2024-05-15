//
//  DrumsView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 13.05.2024.
//

import Foundation

class DrumsView: AlgorithmView {
    var syncopationSlider = SliderView(name: "Синкопирование", value: 0.5, minimum: 0, maximum: 1)
    var complexitySlider = SliderView(name: "Сложность", value: 12, minimum: 0, maximum: 30)

    override init() {
        super.init()
        stack.addArrangedSubview(syncopationSlider)
        stack.addArrangedSubview(complexitySlider)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
