//
//  AlgorithmsView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

class AlgorithmsView: UIView {
    let makeButton = {
        let button = UIButton()
        button.setHeight(40)
        button.setWidth(200)

        return button
    }

    lazy var melodyButton = makeButton()
    lazy var chordsButton = makeButton()
    lazy var rhythmButtom = makeButton()

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.2, alpha: 1)
        let stack = UIStackView(arrangedSubviews: [melodyButton, chordsButton, rhythmButtom])
        stack.axis = .vertical
        addSubview(stack)
        stack.pinHorizontal(to: self, 20)
        stack.pinCenterY(to: self)
        stack.spacing = 12

        melodyButton.setTitle("Генерация мелодий", for: .normal)
        chordsButton.setTitle("Генерация аккордов", for: .normal)
        rhythmButtom.setTitle("Генерация ритма", for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
