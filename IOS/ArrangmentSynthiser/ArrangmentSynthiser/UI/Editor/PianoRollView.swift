//
//  PianoRollView.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 02.04.2024.
//

import SwiftUI
import PianoRoll
import Keyboard
import Tonic

struct PianoRollView: View {
    let pianoRollDelegate: PianoRollDelegate?
    @State var model: PianoRollModel
    @State var selectionX: CGFloat = 185
    @State var selectionY: CGFloat = 291
    @State var selectionWidth: CGFloat = 50
    @State var selectionHeight: CGFloat = 50
    @State var selectionOn: Bool = false
    @ObservedObject var pianoRollSettings = PianoRollSettings()

    init(pianoRollDelegate: PianoRollDelegate?, length: Int, height: Int) {
        self.model = PianoRollModel(notes: [], length: length, height: height)
        self.pianoRollDelegate = pianoRollDelegate
    }

    public var body: some View {
        let dragGesture = DragGesture(minimumDistance: 2).onChanged { value in
            let minX = min(value.startLocation.x, value.location.x)
            let maxX = max(value.startLocation.x, value.location.x)
            let minY = min(value.startLocation.y, value.location.y)
            let maxY = max(value.startLocation.y, value.location.y)
            selectionX = minX + (maxX - minX) / 2
            selectionY = minY + (maxY - minY) / 2
            selectionWidth = maxX - minX
            selectionHeight = maxY - minY
            selectionOn = true
            pianoRollDelegate?.onSelectionMoved()
        }.onEnded { value in
            let location = value.location
            let startLocation = value.startLocation
            let gridSize: CGSize = CGSize(width: 80, height: 40)
            let step1 = Double(location.x / gridSize.width)
            let pitch1 = model.height - Int(location.y / gridSize.height)
            let step2 = Double(startLocation.x / gridSize.width)
            let pitch2 = model.height - Int(startLocation.y / gridSize.height)
            var notes: [PianoRollNote] = []
            model.notes.forEach { note in
                if note.start >= min(step1, step2) && note.start + note.length <= max(step1, step2)
                    && note.pitch >= min(pitch1, pitch2) && note.pitch <= max(pitch1, pitch2) {
                    notes.append(note)
                }
            }

            model.notes = model.notes.filter({ note in
                !notes.contains(note)
            }).map({ note in
                PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, color: .cyan)
            }) + notes.map({ note in
                PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, color: .green)
            })

            selectionOn = false
            pianoRollDelegate?.onSelectionDone(notes)
        }

        ScrollView([.vertical], showsIndicators: true) {
            HStack(alignment: .top) {
                FalseKeyboard(pitchRange: Pitch(intValue: 0)...Pitch(intValue: model.height - 1), root: .C, scale: .chromatic).disabled(true).frame(width: 120)
                ScrollView([.horizontal], showsIndicators: true) {
                    ZStack(alignment: .topLeading) {
                        PianoRoll(model: $model, noteColor: .cyan, gridColor: .black, layout: .horizontal).gesture(dragGesture)
                        Rectangle().fill(.blue).position(x: selectionX, y: selectionY).frame(width: selectionWidth, height: selectionHeight).opacity(selectionOn ? 0.5 : 0.0)
                    }
                }.scrollDisabled(!pianoRollSettings.scrollViewOn)
            }
        }.scrollDisabled(!pianoRollSettings.scrollViewOn).background(Color(white: 0.1)).onChange(of: model) { newValue in
            pianoRollDelegate?.onNotesChange(newValue)
        }
    }
}
