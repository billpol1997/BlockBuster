//
//  MovieCreditsResponseModel.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import Foundation

struct MovieCreditsResponseModel: Decodable {
    let id: Int?
    let cast: [MovieCast]?
    let crew: [MovieCrew]?
}

struct MovieCast: Decodable, Identifiable {
    let id: Int?
    let name: String?
    let original_name: String?
    let character: String?
    let profile_path: String?
    let credit_id: String?
    let cast_id: Int?
    let order: Int?
    let gender: Int?
    let known_for_department: String?
    let adult: Bool?
    let popularity: Double?
}

struct MovieCrew: Decodable, Identifiable {
    let id: Int?
    let name: String?
    let original_name: String?
    let department: String?
    let job: String?
    let profile_path: String?
    let credit_id: String?
    let gender: Int?
    let known_for_department: String?
    let adult: Bool?
    let popularity: Double?
}
