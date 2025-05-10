//
//  SongViewModel.swift
//  CarPlay
//
//  Created by Apple on 09/05/25.
//

import Foundation

// MARK: - Presentation Layer

// SongListViewModel.swift
final class SongListViewModel {
    private let fetchSongsUseCase: FetchSongsUseCase
    private(set) var songs: [Song] = []

    var onSongsUpdated: (() -> Void)?
    var onSongSelected: ((Song) -> Void)?

    init(fetchSongsUseCase: FetchSongsUseCase) {
        self.fetchSongsUseCase = fetchSongsUseCase
        loadSongs()
    }

    private func loadSongs() {
        songs = fetchSongsUseCase.execute()
        onSongsUpdated?()
    }

    func selectSong(at index: Int) {
        guard index < songs.count else { return }
        onSongSelected?(songs[index])
    }
}
