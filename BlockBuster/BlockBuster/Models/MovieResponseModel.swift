//
//  MovieModel.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import Foundation

struct MovieResponseModel: Decodable, Identifiable {
    // Common/list-like fields
    let adult: Bool?
    let backdrop_path: String?
    let id: Int
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?

    // Details-specific fields
    let belongs_to_collection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let imdb_id: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
}

struct BelongsToCollection: Decodable {
    let id: Int?
    let name: String?
    let poster_path: String?
    let backdrop_path: String?
}

