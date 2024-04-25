//
//  UIExtensions.swift
//  vkmelnikPW3
//
//  Created by Vsevolod Melnik on 18.10.2021.
//

import UIKit


// Extensions that allow to customize some UI elements.

extension UIView {
    func setupGradientBackground() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let colors = [#colorLiteral(red: 0.9558096851, green: 0.9558096851, blue: 0.9558096851, alpha: 1), #colorLiteral(red: 0.7920269633, green: 0.7920269633, blue: 0.7920269633, alpha: 1)]
        let bounds = self.bounds
        gradient.frame = bounds
        gradient.colors = [colors[0].cgColor, colors[1].cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        return gradient
    }

    func getThumbGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        let bounds = self.bounds
        gradient.frame = bounds
        gradient.colors = [colors[0].cgColor, colors[1].cgColor]
        gradient.locations = [0.2, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        return gradient
    }

    func getReflection(_ colors: [UIColor] = [#colorLiteral(red: 0.8631671386, green: 0.8631671386, blue: 0.8631671386, alpha: 0.138755498), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3890394677)]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let offset = CGFloat(3)
        gradient.frame = CGRect(x: bounds.origin.x + offset, y: bounds.origin.y + bounds.height / 2, width: bounds.width - offset, height: bounds.height / 2)
        gradient.colors = [colors[0].cgColor, colors[1].cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.cornerRadius = SynthStyle.cornerRadius
        return gradient
    }

    func getReflection2() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5), #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 0.1991365087), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1480583131)]
        let height = CGFloat(30)
        gradient.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: height)
        gradient.colors = [colors[0].cgColor, colors[1].cgColor, colors[2].cgColor]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.cornerRadius = 12
        return gradient
    }

    func getGlass(_ colors: [UIColor] = [#colorLiteral(red: 0.2487239394, green: 0.2487239394, blue: 0.2487239394, alpha: 0.3111386637), #colorLiteral(red: 0.4987951133, green: 0.4987951133, blue: 0.4987951133, alpha: 0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)], reflection: [UIColor] = [#colorLiteral(red: 0.8631671386, green: 0.8631671386, blue: 0.8631671386, alpha: 0.138755498), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3890394677)]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let bounds = self.bounds
        gradient.frame = bounds
        gradient.colors = [colors[0].cgColor, colors[1].cgColor, colors[2].cgColor]
        gradient.locations = [0.0, 0.20, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.cornerRadius = SynthStyle.cornerRadius
        gradient.masksToBounds = true
        gradient.addSublayer(getReflection(reflection))
        return gradient
    }

    func getShade() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3128407396), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3049552497)]
        gradient.frame = bounds
        gradient.colors = [colors[0].cgColor, colors[1].cgColor, colors[2].cgColor, colors[3].cgColor]
        gradient.locations = [0.0, 0.20, 0.80, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.cornerRadius = 15
        return gradient
    }

    func getGlass2(_ colors: [UIColor] = [#colorLiteral(red: 0.8631671386, green: 0.8631671386, blue: 0.8631671386, alpha: 0), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3333843562)]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let offset = CGFloat(70)
        gradient.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.height / 2 - offset, width: bounds.width, height: offset)
        gradient.colors = [colors[0].cgColor, colors[1].cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        return gradient
    }

    func getGlass3() -> CALayer {
        let layer = CALayer();
        layer.backgroundColor = #colorLiteral(red: 0.3788720929, green: 0.3729515498, blue: 1, alpha: 0.1145658118)
        let width = CGFloat(35)
        layer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.height / 2 - width / 2, width: bounds.width, height: width)
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        return layer
    }

    // Make PickerView or DatePickerView to look like in older IOS versions.
    func makeRetroPicker() -> CALayer {
        let retroLayer = CALayer()
        layer.cornerRadius = SynthStyle.cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = 6
        layer.borderColor = UIColor.black.cgColor
        retroLayer.addSublayer(getShade())
        retroLayer.addSublayer(getGlass3())
        retroLayer.addSublayer(getGlass2([#colorLiteral(red: 0.8631671386, green: 0.8631671386, blue: 0.8631671386, alpha: 0), #colorLiteral(red: 1, green: 0.208245486, blue: 0, alpha: 0.3333843562)]))
        layer.addSublayer(retroLayer)

        return retroLayer
    }
}

extension UISwitch {
    // Make switch look like in older IOS versions.
    func makeRetroUI() {
        thumbTintColor = UIColor(patternImage: getThumbGradient().createGradientImage(size: self.bounds.size)!)
        onTintColor = #colorLiteral(red: 0.003921568627, green: 0.4549019608, blue: 1, alpha: 1)
        layer.addSublayer(getGlass())
    }

}

extension CAGradientLayer {
    public func createGradientImage(size: CGSize) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

class RetroStack: UIStackView {
    lazy var gradientLayer: CALayer = makeRetroUI()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        layer.cornerRadius = SynthStyle.cornerRadius
        layer.masksToBounds = true
    }

    func makeRetroUI() -> CALayer {
        let gradient = getGlass(reflection: [#colorLiteral(red: 0.8631671386, green: 0.8631671386, blue: 0.8631671386, alpha: 0.08800082113), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1796343537)])
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.addSublayer(gradient)
        layer.cornerRadius = SynthStyle.cornerRadius

        return gradient
    }
}

class RetroUIButton: UIButton {
    lazy var gradientLayer: CALayer = makeRetroUI()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    // Make button look like in older IOS versions.
    func makeRetroUI() -> CALayer {
        let gradient = getGlass(reflection: [#colorLiteral(red: 0.8631671386, green: 0.8631671386, blue: 0.8631671386, alpha: 0.08800082113), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1796343537)])
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.addSublayer(gradient)
        layer.cornerRadius = SynthStyle.cornerRadius

        return gradient
    }

    static func makeButton() -> RetroUIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 8, leading: 14, bottom: 8, trailing: 14)
        let button = RetroUIButton(configuration: configuration)
        button.setTitleColor(.white, for: .normal)

        return button
    }
}

class RetroUIPicker: UIPickerView {
    lazy var gradientLayer: CALayer = makeRetroPicker()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        for layer in gradientLayer.sublayers ?? [] {
            layer.frame = self.bounds
        }
    }
}
