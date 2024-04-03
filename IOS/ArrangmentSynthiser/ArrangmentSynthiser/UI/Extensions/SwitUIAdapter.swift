//
//  SwitUIAdapter.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 02.04.2024.
//

import UIKit
import SwiftUI

class SwiftUIAdapter<Content> where Content : View {
    private(set) var view: Content!
    weak private(set) var parent: UIViewController!
    private(set) var uiView : WrappedView
    private var hostingController: UIHostingController<Content>

    init(view: Content, parent: UIViewController) {
        self.view = view
        self.parent = parent
        hostingController = UIHostingController(rootView: view)
        parent.addChild(hostingController)
        hostingController.didMove(toParent: parent)
        uiView = WrappedView(view: hostingController.view)
    }

    deinit {
        hostingController.removeFromParent()
        hostingController.didMove(toParent: nil)
    }
}

class WrappedView: UIView {
    private (set) var view: UIView!

    init(view: UIView) {
        self.view = view
        super.init(frame: CGRect.zero)
        addSubview(view)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
}
