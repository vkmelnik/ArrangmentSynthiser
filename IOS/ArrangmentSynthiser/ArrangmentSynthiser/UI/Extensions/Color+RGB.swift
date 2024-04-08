//
//  Color+RGB.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 08.04.2024.
//

import UIKit
import SwiftUI

extension Color {
    var redValue: CGFloat {
        UIColor(self).cgColor.components?[0] ?? 0
    }

    var greenValue: CGFloat {
        UIColor(self).cgColor.components?[1] ?? 0
    }

    var blueValue: CGFloat {
        UIColor(self).cgColor.components?[2] ?? 0
    }

    var alphaValue: CGFloat {
        UIColor(self).cgColor.components?[3] ?? 0
    }
}
