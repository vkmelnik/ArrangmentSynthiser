//
//  StorageInteractor.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 28.04.2024.
//

import PianoRoll
import Foundation

class StorageInteractor {
    static let shared = StorageInteractor()
    var delegate: StorageDelegate?
    var currentProjectName: String = "Новый проект"

    private init() { }

    func save(name: String, notes: [PianoRollNote], length: Double, tempo: Double) {
        let project = createProjectModel(name: name, notes: notes, length: length, tempo: tempo)

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(project)
            let json = String(data: jsonData, encoding: .utf8)

            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appendingPathComponent(project.name + ".arrsynthproject")
            try json!.write(to: pathWithFilename,
                            atomically: true,
                            encoding: .utf8)
            }
        } catch {
            print("Unable to save project.")
        }
    }

    func saveMIDI(name: String, data: Data) -> URL? {
        do {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent(name + ".midi")
                try data.write(to: pathWithFilename)
                return pathWithFilename
            }
        } catch {
            print("Unable to save project.")
        }

        return nil
    }

    func deleteProject(named: String) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        do {
            let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            for element in files {
                if element.pathExtension.hasSuffix("arrsynthproject") && element.deletingPathExtension().lastPathComponent == named {
                    try FileManager.default.removeItem(at: element)
                }
            }

            return
        } catch {
            return
        }
    }

    func loadNames() -> [String] {
        var names: [String] = []
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        do {
            let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            for element in files {
                if element.pathExtension.hasSuffix("arrsynthproject") {
                    names.append(element.deletingPathExtension().lastPathComponent)
                }
            }

            return names
        } catch {
            return []
        }
    }

    func newProject() {
        delegate?.load(ProjectModel(name: "Новый проект 1", length: 16, tempo: 120, notes: [.init(start: 0, length: 0, pitch: 0, text: nil)]))
        delegate?.load(ProjectModel(name: "Новый проект 1", length: 16, tempo: 120, notes: []))
    }

    func loadProject(named: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            print("Can not access document directory")
            return
        }
        do {
            guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let files = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            for element in files {
                if element.pathExtension.hasSuffix("arrsynthproject") {
                    if element.deletingPathExtension().lastPathComponent == named {
                        let jsonString = try String(contentsOf: documentDirectory.appendingPathComponent(element.lastPathComponent), encoding: .utf8)
                        let project = try JSONDecoder().decode(ProjectModel.self, from: jsonString.data(using: .utf8)!)

                        delegate?.load(project)
                        return
                    }
                }
            }
        } catch {
            return
        }
    }

    private func createProjectModel(name: String, notes: [PianoRollNote], length: Double, tempo: Double) -> ProjectModel {
        ProjectModel(
            name: name,
            length: length,
            tempo: tempo,
            notes: notes.map({ note in
                ProjectModel.StorageNote(start: note.start, length: note.length, pitch: note.pitch, text: note.text)
            })
        )
    }
}
