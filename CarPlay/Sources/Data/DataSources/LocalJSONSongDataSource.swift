//
//  LocalJSONSongDataSource.swift
//  CarPlayDemo
//
//  Created by Apple on 09/05/25.
//

import Foundation

// LocalJSONSongDataSource.swift
final class LocalJSONSongDataSource {
    func loadSongs() -> [Song] {
        guard let url = Bundle.main.url(forResource: "sample_songs", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONDecoder().decode(SongListWrapper.self, from: data) else {
            return []
        }
        return json.songs
    }

    private struct SongListWrapper: Codable {
        let songs: [Song]
    }
}
