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
    @State var selectedModel: PianoRollModel
    @State var selectionX: CGFloat = 185
    @State var selectionY: CGFloat = 291
    @State var selectionWidth: CGFloat = 50
    @State var selectionHeight: CGFloat = 50
    @State var selectionOn: Bool = false
    @ObservedObject var pianoRollSettings = PianoRollSettings()

    @GestureState var offset = CGSize.zero

    init(pianoRollDelegate: PianoRollDelegate?, length: Int, height: Int) {
        self.model = PianoRollModel(notes: [], length: length, height: height)
        self.selectedModel = PianoRollModel(notes: [], length: length, height: height)
        self.pianoRollDelegate = pianoRollDelegate
    }

    var body: some View {
        let pianoRoll = PianoRoll(model: $model, noteColor: InstrumentsCoding.defaultColor, gridColor: .black, layout: .horizontal)
        let selectedPianoRoll = PianoRoll(model: $selectedModel, noteColor: InstrumentsCoding.defaultColor, gridColor: .clear, layout: .horizontal).disabled(true)

        let selectionDragGesture = DragGesture(minimumDistance: 0.1)
            .updating($offset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                model.notes = Array(model.notes.prefix(model.notes.count - selectedModel.notes.count))
                            + selectedModel.notes.map { note in
                    snap(note: note, offset: value.translation)
                }

                selectedModel.notes = []
            }

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

            let selectedNotes = notes.map({ note in
                if let instrument = pianoRollSettings.currentInstrument {
                    return PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, text: String(instrument), color: InstrumentsCoding.colors[instrument])
                } else {
                    return PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, text: note.text, color: InstrumentsCoding.getSelectedColor(note))
                }
            })

            model.notes = model.notes.filter({ note in
                !notes.contains(note)
            }).map({ note in
                PianoRollNote(start: note.start, length: note.length, pitch: note.pitch, text: note.text, color: InstrumentsCoding.getColor(note))
            }) + selectedNotes

            selectedModel.notes = pianoRollSettings.currentInstrument == nil ? notes : []

            selectionOn = false
            pianoRollSettings.currentInstrument = nil
            // pianoRollSettings.scrollViewOn = true
            pianoRollDelegate?.onSelectionDone(selectedNotes)
        }

        ScrollView([.vertical], showsIndicators: true) {
            HStack(alignment: .top) {
                FalseKeyboard(pitchRange: Pitch(intValue: 0)...Pitch(intValue: model.height - 1), root: .C, scale: .chromatic).disabled(true).frame(width: 120)
                ScrollView([.horizontal], showsIndicators: true) {
                    ZStack(alignment: .topLeading) {
                        pianoRoll.disabled(!pianoRollSettings.scrollViewOn).gesture(dragGesture)
                        ZStack {
                            selectedPianoRoll.opacity(selectedModel.notes.count != 0 ? 1.0 : 0.0).offset(offset)
                        }.gesture(selectionDragGesture)
                        Rectangle().fill(.gray).position(x: selectionX, y: selectionY).frame(width: selectionWidth, height: selectionHeight).opacity(selectionOn ? 0.5 : 0.0)
                    }
                }.scrollDisabled(!pianoRollSettings.scrollViewOn)
            }
        }.scrollDisabled(!pianoRollSettings.scrollViewOn).background(Color(white: 0.1)).onChange(of: model) { newValue in
            pianoRollDelegate?.onNotesChange(newValue)
        }.onChange(of: pianoRollSettings.length) { newValue in
            model = PianoRollModel(notes: model.notes.filter({ note in
                Int(note.start) < newValue
            }), length: pianoRollSettings.length, height: model.height)
        }.onChange(of: pianoRollSettings.addedNotes) { newValue in
            if pianoRollSettings.scrollViewOn {
                model = PianoRollModel(notes: newValue, length: pianoRollSettings.length, height: model.height)
            } else {
                let filteredNotes = model.notes.filter({ note in
                    !selectedModel.notes.contains(where: { note2 in
                        note.pitch == note2.pitch && note.length == note2.length && note.text == note2.text && note.start == note2.start
                    })
                })
                let minPosition = selectedModel.notes.map { note in note.start }.min() ?? 0
                selectedModel.notes = []
                let correctedNotes: [PianoRollNote] = newValue.map { note in
                    PianoRollNote(start: note.start + minPosition, length: note.length, pitch: note.pitch, text: note.text, color: note.color)
                }

                pianoRollDelegate?.onSelectionDone([])
                model = PianoRollModel(notes: filteredNotes + correctedNotes, length: pianoRollSettings.length, height: model.height)
            }
        }.onChange(of: pianoRollSettings.scrollViewOn) { newValue in
            if newValue {
                selectedModel.notes = []
            }
        }.edgesIgnoringSafeArea([.leading, .trailing])
    }

    func snap(note: PianoRollNote, offset: CGSize, lengthOffset: CGFloat = 0.0) -> PianoRollNote {
        var n = note
        let gridSize = CGSize(width: 80, height: 40)
        n.start += offset.width / gridSize.width
        n.start = max(0, n.start)
        n.start = min(Double(model.length - 1), n.start)
        n.pitch -= Int(round(offset.height / CGFloat(gridSize.height)))
        n.pitch = max(1, n.pitch)
        n.pitch = min(model.height, n.pitch)
        n.length += lengthOffset / gridSize.width
        n.length = max(1, n.length)
        n.length = min(Double(model.length), n.length)
        n.length = min(Double(model.length) - n.start, n.length)
        return n
    }
}
