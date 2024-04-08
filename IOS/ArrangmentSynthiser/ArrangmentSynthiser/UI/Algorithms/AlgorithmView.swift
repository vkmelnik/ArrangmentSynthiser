//
//  MelodyView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import UIKit

class AlgorithmView: UIView {
    let makeButton = {
        let button = UIButton()
        button.setHeight(40)
        button.setWidth(200)

        return button
    }

    lazy var generateButton = makeButton()
    lazy var backButton = makeButton()
    var stack = UIStackView()

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.15, alpha: 1)
        stack.axis = .vertical
        addSubview(stack)
        stack.pinHorizontal(to: self, 20)
        stack.pinCenterY(to: self)
        stack.spacing = 12

        generateButton.setTitle("Сгенерировать", for: .normal)
        addSubview(generateButton)
        generateButton.pinBottom(to: safeAreaLayoutGuide.bottomAnchor)
        generateButton.pinHorizontal(to: self, 20)

        backButton.setTitle("Назад", for: .normal)
        addSubview(backButton)
        backButton.pinTop(to: safeAreaLayoutGuide.topAnchor)
        backButton.pinHorizontal(to: self, 20)
        backButton.addTarget(self, action: #selector(onBackButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func onBackButton() {
        removeFromSuperview()
    }
}
