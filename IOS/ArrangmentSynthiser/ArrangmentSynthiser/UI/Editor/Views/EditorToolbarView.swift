//
//  EditorToolbarView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

/// Верхняя панель редактора.
class EditorToolbarView: UIView {
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("▶", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3344596538, green: 0.3641954376, blue: 0.4409706901, alpha: 1)
        button.setHeight(40)
        button.setWidth(50)

        return button
    }()

    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Настройки", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3344596538, green: 0.3641954376, blue: 0.4409706901, alpha: 1)
        button.setHeight(40)
        button.setWidth(120)

        return button
    }()

    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выделить", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3344596538, green: 0.3641954376, blue: 0.4409706901, alpha: 1)
        button.setHeight(40)
        button.setWidth(120)

        return button
    }()

    lazy var synthButton: UIButton = {
        let button = UIButton()
        button.setTitle("Синтезатор", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        button.setHeight(40)
        button.setWidth(120)

        return button
    }()

    lazy var mandolinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Мандолина", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        button.setHeight(40)
        button.setWidth(120)

        return button
    }()

    lazy var percussionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перкуссия", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        button.setHeight(40)
        button.setWidth(120)

        return button
    }()

    lazy var algorithmsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Алгоритмы", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3344596538, green: 0.3641954376, blue: 0.4409706901, alpha: 1)
        button.setHeight(40)
        button.setWidth(150)

        return button
    }()

    init() {
        super.init(frame: .zero)
        let stack = UIStackView(arrangedSubviews: [settingsButton, selectButton, synthButton, mandolinButton, percussionButton])
        addSubview(stack)
        stack.pinLeft(to: self, 10)
        stack.pinCenterY(to: self)
        stack.layoutIfNeeded()
        stack.makeRetroPicker()

        addSubview(playButton)
        playButton.pinLeft(to: stack.trailingAnchor, 20)
        playButton.pinCenterY(to: self)
        playButton.layoutIfNeeded()
        playButton.makeRetroUI()

        addSubview(algorithmsButton)
        algorithmsButton.pinRight(to: self, 10)
        algorithmsButton.pinCenterY(to: self)
        algorithmsButton.layoutIfNeeded()
        algorithmsButton.makeRetroUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
