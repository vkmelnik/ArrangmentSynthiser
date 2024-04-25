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
        button.setTitle(" ▶ ", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1539273262, green: 0.1691191494, blue: 0.2076610327, alpha: 1)

        return button
    }()

    lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(" ■ ", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1539273262, green: 0.1691191494, blue: 0.2076610327, alpha: 1)

        return button
    }()

    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Настройки", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1212012991, green: 0.1331564486, blue: 0.1635183096, alpha: 1)

        return button
    }()

    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выделить", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3344596538, green: 0.3641954376, blue: 0.4409706901, alpha: 1)

        return button
    }()

    lazy var synthButton: UIButton = {
        let button = UIButton()
        button.setTitle("Синтезатор", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)

        return button
    }()

    lazy var mandolinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Мандолина", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)

        return button
    }()

    lazy var percussionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перкуссия", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)

        return button
    }()

    lazy var algorithmsButton: RetroUIButton = {
        let button = RetroUIButton.makeButton()
        button.setTitle("Алгоритмы", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1061571315, green: 0.1166248992, blue: 0.1432257295, alpha: 1)

        return button
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = SynthColors.backgroundSecondary

        let topView = UIView()
        topView.backgroundColor = backgroundColor
        addSubview(topView)
        topView.pinHorizontal(to: self)
        topView.setHeight(50)
        topView.pinBottom(to: topAnchor)
        layer.masksToBounds = false

        let stack = RetroStack(arrangedSubviews: [settingsButton, selectButton, synthButton, mandolinButton, percussionButton])
        addSubview(stack)
        stack.pinLeft(to: self, 10).priority = .init(900)
        stack.pinLeft(to: self.safeAreaLayoutGuide.leadingAnchor, -30, .grOE).priority = .init(1000)
        stack.pinCenterY(to: self)

        let playStack = RetroStack(arrangedSubviews: [playButton, stopButton])
        playStack.spacing = 2
        addSubview(playStack)
        playStack.pinLeft(to: stack.trailingAnchor, 20, .grOE).priority = .init(500)
        playStack.pinCenterX(to: self).priority = .init(400)
        playStack.pinCenterY(to: self)

        addSubview(algorithmsButton)
        algorithmsButton.pinRight(to: self, 10, .lsOE)
        algorithmsButton.pinRight(to: self.safeAreaLayoutGuide.trailingAnchor, -30, .lsOE)
        algorithmsButton.pinCenterY(to: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
