//
//  MelodyView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 04.04.2024.
//

import UIKit

class AlgorithmView: UIView {
    let makeButton = {
        let button = RetroUIButton.makeButton()
        button.setHeight(40)
        button.setWidth(200)

        return button
    }

    var scrollView = UIScrollView()
    lazy var generateButton = makeButton()
    lazy var backButton = makeButton()
    var stack = UIStackView()

    init() {
        super.init(frame: .zero)
        backgroundColor = SynthStyle.backgroundSecondary

        addSubview(scrollView)
        scrollView.pinHorizontal(to: self)
        scrollView.pinTop(to: safeAreaLayoutGuide.topAnchor)
        scrollView.pinBottom(to: safeAreaLayoutGuide.bottomAnchor)
        generateButton.setTitle("Сгенерировать", for: .normal)

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.pin(to: scrollView)

        contentView.addSubview(generateButton)
        generateButton.pinBottom(to: contentView.safeAreaLayoutGuide.bottomAnchor)
        generateButton.pinHorizontal(to: contentView, 20)

        backButton.setTitle("Назад", for: .normal)
        contentView.addSubview(backButton)
        backButton.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor)
        backButton.pinHorizontal(to: contentView, 20)
        backButton.addTarget(self, action: #selector(onBackButton), for: .touchUpInside)

        stack.axis = .vertical
        contentView.addSubview(stack)
        stack.pinHorizontal(to: contentView, 20)
        stack.pinTop(to: backButton.bottomAnchor, 20)
        stack.pinBottom(to: generateButton.topAnchor, 20)
        stack.spacing = 12
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func onBackButton() {
        EditorAudioInteractor.shared.stopGeneration()
        removeFromSuperview()
    }
}
