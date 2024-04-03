//
//  SliderView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

/// Слайдер с названием
class SliderView: UIView {
    lazy var title: UILabel = {
        let title = UILabel()

        return title
    }()

    lazy var slider: UISlider = {
        let slider = UISlider()


        return slider
    }()

    init(name: String, value: Float, minimum: Float, maximum: Float) {
        super.init(frame: .zero)
        title.text = name
        addSubview(title)
        title.pinLeft(to: self)
        title.pinTop(to: self)
        addSubview(slider)
        slider.pinHorizontal(to: self)
        slider.pinTop(to: title.bottomAnchor)
        slider.pinBottom(to: self)
        slider.minimumValue = minimum
        slider.maximumValue = maximum
        slider.isContinuous = true
        slider.value = value
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
