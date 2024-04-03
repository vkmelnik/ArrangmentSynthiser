//
//  FalseKeyboard.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 03.04.2024.
//

import SwiftUI
@_exported import Tonic
import Keyboard

/// Touch-oriented musical keyboard
public struct FalseKeyboard: View {
    let content: (Pitch, Bool) -> KeyboardKey = {
        KeyboardKey(
            pitch: $0,
            isActivated: $1,
            flatTop: false,
            alignment: .trailing
        )
    }

    var pitchRange: ClosedRange<Pitch>
    var root: NoteClass
    var scale: Scale

    /// Body enclosing the various layout views
    public var body: some View {
        ZStack {
            VerticalIsomorphic<KeyboardKey>(content: content,
                               pitchRange: pitchRange,
                               root: root,
                               scale: scale)
        }
    }
}

struct VerticalIsomorphic<Content>: View where Content: View {
    let content: (Pitch, Bool) -> Content
    var pitchRange: ClosedRange<Pitch>
    var root: NoteClass
    var scale: Scale

    var pitchesToShow: [Pitch] {
        var pitchArray: [Pitch] = []
        let key = Key(root: root, scale: scale)
        for pitch in pitchRange where pitch.existsNaturally(in: key) {
            pitchArray.append(pitch)
        }
        return Array(pitchArray)
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(pitchesToShow.reversed(), id: \.self) { pitch in
                KeyContainer(pitch: pitch,
                             content: content)
            }
        }
        .clipShape(Rectangle())
    }
}

struct KeyContainer<Content: View>: View {
    let content: (Pitch, Bool) -> Content

    var pitch: Pitch

    var zIndex: Int

    init(pitch: Pitch,
         zIndex: Int = 0,
         @ViewBuilder content: @escaping (Pitch, Bool) -> Content)
    {
        self.pitch = pitch
        self.zIndex = zIndex
        self.content = content
    }

    func rect(rect: CGRect) -> some View {
        content(pitch, false)
            .contentShape(Rectangle()) // Added to improve tap/click reliability
            .preference(key: KeyRectsKey.self,
                        value: [KeyRectInfo(rect: rect,
                                            pitch: pitch,
                                            zIndex: zIndex)])
    }

    public var body: some View {
        GeometryReader { proxy in
            rect(rect: proxy.frame(in: .global))
        }
    }
}

/// For accumulating key rects.
struct KeyRectsKey: PreferenceKey {
    static var defaultValue: [KeyRectInfo] = []

    static func reduce(value: inout [KeyRectInfo], nextValue: () -> [KeyRectInfo]) {
        value.append(contentsOf: nextValue())
    }
}

struct KeyRectInfo: Equatable {
    var rect: CGRect
    var pitch: Pitch
    var zIndex: Int = 0
}
