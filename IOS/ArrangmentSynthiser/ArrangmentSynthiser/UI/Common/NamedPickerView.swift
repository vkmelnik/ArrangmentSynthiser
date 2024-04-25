//
//  NamePickerView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 25.04.2024.
//

import UIKit

/// Слайдер с названием
class NamedPickerView: UIView {
    var title = UILabel()
    var pickerView = RetroUIPicker()

    init(name: String) {
        super.init(frame: .zero)
        title.text = name
        title.font = .boldSystemFont(ofSize: 20)
        title.textColor = .white
        addSubview(title)
        title.pinCenterX(to: self)
        title.pinTop(to: self)
        addSubview(pickerView)
        pickerView.pinHorizontal(to: self)
        pickerView.pinTop(to: title.bottomAnchor, 8)
        pickerView.pinBottom(to: self)
        pickerView.setHeight(100)
        pickerView.backgroundColor = #colorLiteral(red: 0.8696566224, green: 0.6382841468, blue: 0.2484662235, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
