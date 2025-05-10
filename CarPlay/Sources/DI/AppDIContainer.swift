//
//  Untitled.swift
//  CarPlayDemo
//
//  Created by Apple on 09/05/25.
//

// MARK: - DI Layer

// AppDIContainer.swift
final class AppDIContainer {
    static let shared = AppDIContainer()

    private init() {}

    func makeSongListViewModel() -> SongListViewModel {
        let dataSource = LocalJSONSongDataSource()
        let repository = LocalSongRepository(dataSource: dataSource)
        return SongListViewModel(fetchSongsUseCase: repository)
    }
}
