//
//  Movie.swift
//  ReelSpin
//
//  Created by mike liu on 2025/5/3.
//

struct Movie: Decodable {
    let title: String
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case title, overview
        case posterPath = "poster_path"
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
