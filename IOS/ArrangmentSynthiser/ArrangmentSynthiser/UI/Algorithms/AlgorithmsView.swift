//
//  AlgorithmsView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import UIKit

class AlgorithmsView: UIView {
    var views: [UIView]

    let makeButton = {
        let button = RetroUIButton.makeButton()
        button.setHeight(40)
        button.setWidth(mode: .grOE, 200)

        return button
    }

    init(views: [UIView], titles: [String]) {
        self.views = views
        super.init(frame: .zero)
        backgroundColor = SynthColors.backgroundSecondary
        let stack = UIStackView()
        stack.axis = .vertical
        addSubview(stack)
        stack.pinHorizontal(to: self, 20)
        stack.pinCenterY(to: self)
        stack.spacing = 12

        for i in 0..<views.count {
            let button = makeButton()
            button.setTitle(titles[i], for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(showAlgorithm), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func showAlgorithm(sender:UIButton) {
        let view = views[sender.tag]
        addSubview(view)
        view.pin(to: self)
        layoutIfNeeded()
    }
}
