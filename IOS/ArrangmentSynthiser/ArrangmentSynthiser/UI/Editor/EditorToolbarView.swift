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

    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("✎", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3344596538, green: 0.3641954376, blue: 0.4409706901, alpha: 1)
        button.setHeight(40)
        button.setWidth(50)

        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubview(playButton)
        playButton.pinCenter(to: self)
        playButton.layoutIfNeeded()
        playButton.makeRetroUI()

        addSubview(selectButton)
        selectButton.pinLeft(to: self, 20)
        selectButton.pinCenterY(to: self)
        selectButton.layoutIfNeeded()
        selectButton.makeRetroUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
