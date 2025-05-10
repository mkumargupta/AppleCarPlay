//
//  SongListViewController.swift
//  CarPlay
//
//  Created by Apple on 09/05/25.
//

// MARK: - SongListViewController.swift

// SongListViewController.swift
import UIKit

final class SongListViewController: UIViewController {
    private let viewModel: SongListViewModel
    private let tableView = UITableView()

    init(viewModel: SongListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Songs"
        setupTableView()
        bindViewModel()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func bindViewModel() {
        viewModel.onSongsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onSongSelected = { [weak self] song in
            AlertManager.shared.showAlert(title: song.songname)
            NotificationCenter.default.post(name: .songSelected, object: song)
        }
    }
}

extension SongListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let song = viewModel.songs[indexPath.row]
        cell.textLabel?.text = song.songname
        cell.detailTextLabel?.text = song.artistname
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectSong(at: indexPath.row)
    }
}

// MARK: - Coordinator

// SongListCoordinator.swift
final class SongListCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = AppDIContainer.shared.makeSongListViewModel()
        let viewController = SongListViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }
}
