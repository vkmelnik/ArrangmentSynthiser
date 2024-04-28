//
//  StorageViewController.swift
//  ArrangmentSynthiser
//
//  Created by Мельник Всеволод on 28.04.2024.
//

import UIKit

class StorageViewController: UIViewController {
    lazy var tableView = {
        let tableView = UITableView()

        return tableView
    }()

    var projectsNames: [String] = ["Проект 1", "Проект 2", "Проект 3"]

    override func viewDidLoad() {
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        projectsNames = StorageInteractor.shared.loadNames()
        tableView.reloadData()
    }

    private func configureUI() {
        view.backgroundColor = SynthStyle.backgroundPrimary
        tableView.backgroundColor = SynthStyle.backgroundPrimary
        view.addSubview(tableView)
        tableView.register(StorageCell.self, forCellReuseIdentifier: "StorageCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinHorizontal(to: view)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }

    private func onDelete(_ index: Int) {
        StorageInteractor.shared.deleteProject(named: projectsNames[index])
        projectsNames.remove(at: index)
        tableView.reloadData()
    }

    private func onLoad(_ index: Int) {
        StorageInteractor.shared.loadProject(named: projectsNames[index])
        dismiss(animated: true)
    }

    private func onAdd() {
        StorageInteractor.shared.newProject()
        dismiss(animated: true)
    }
}

extension StorageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectsNames.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath) as? StorageCell else { return UITableViewCell() }
        if indexPath.row < projectsNames.count {
            cell.backgroundColor = SynthStyle.backgroundSecondary
            cell.label.textColor = .white
            cell.label.text = projectsNames[indexPath.row]
        } else {
            cell.backgroundColor = .clear
            cell.label.textColor = .blue
            cell.label.text = "Добавить"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < projectsNames.count {
            onLoad(indexPath.row)
        } else {
            onAdd()
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            onDelete(indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
