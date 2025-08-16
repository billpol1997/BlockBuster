//
//  PopularMoviesModel.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import Foundation

struct PopularMoviesResponseModel: Decodable {
    let page: Int?
    let results: [MoviePopularItem]?
    let total_pages: Int?
    let total_results: Int?
}

struct MoviePopularItem: Decodable, Identifiable {
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int?
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
}
