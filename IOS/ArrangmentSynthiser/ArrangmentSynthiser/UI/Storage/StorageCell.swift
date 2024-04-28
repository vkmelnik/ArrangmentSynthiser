//
//  StorageCell.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 28.04.2024.
//

import UIKit

class StorageCell: UITableViewCell {
    var label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        label.pin(to: self, 8)
        backgroundColor = SynthStyle.backgroundSecondary
        label.textColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
