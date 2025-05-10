//
//  SongRepository.swift
//  CarPlayDemo
//
//  Created by Apple on 09/05/25.
//

// LocalSongRepository.swift
final class LocalSongRepository: FetchSongsUseCase {
    private let dataSource: LocalJSONSongDataSource

    init(dataSource: LocalJSONSongDataSource) {
        self.dataSource = dataSource
    }

    func execute() -> [Song] {
        return dataSource.loadSongs()
    }
}
